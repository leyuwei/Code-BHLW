// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.21;

import "./SCSC.sol";

/// @notice Filename-aware Ethereum interface for the B-HLW application workflow.
/// @dev Per-LD FIFO occupancy and optical admission are maintained by the AP app.
contract STSC is SCSC {
    mapping(address => bool) public participantApproval;
    mapping(int256 => address) public userSigner;
    mapping(int256 => address) public ldController;
    mapping(uint256 => mapping(int256 => string)) public requestedFiles;
    mapping(uint256 => mapping(int256 => int256)) public assignedLD;

    event ParticipationApproved(address indexed participant, bool approved);
    event UserEnrolled(int256 indexed userId, address indexed signer);
    event LDEnrolled(int256 indexed LDId, address indexed controller);
    event ContentRequested(uint256 indexed batch, int256 indexed userId, string filename);

    function approveParticipation(bool approved) external {
        participantApproval[msg.sender] = approved;
        emit ParticipationApproved(msg.sender, approved);
    }

    function setUserSigner(int256 userId, address signer) external {
        require(msg.sender == owner, "Only owner");
        require(userId > 0 && userId <= getUserCount(), "Invalid user ID");
        userSigner[userId] = signer; // zero revokes the enrollment
        emit UserEnrolled(userId, signer);
    }

    function setLDController(int256 LDId, address controller) external {
        require(msg.sender == owner, "Only owner");
        require(LDId > 0 && LDId <= getLDCount(), "Invalid LD ID");
        ldController[LDId] = controller;
        emit LDEnrolled(LDId, controller);
    }

    // Prevent an AP from bypassing the filename/participation interface.
    function findPair(int256[] memory, int256[3][] memory) public override onlyOperator {
        revert("Use filename request interface");
    }

    function findPair(int256[] memory ids, int256[3][] memory coordinates, string[] memory filenames)
        public onlyOperator
    {
        require(participantApproval[msg.sender], "AP approval required");
        require(ids.length == filenames.length, "Filename length mismatch");
        for (uint256 i = 0; i < ids.length; i++) {
            require(bytes(filenames[i]).length > 0 && bytes(filenames[i]).length <= 255, "Invalid filename");
            address signer = userSigner[ids[i]];
            require(signer != address(0) && participantApproval[signer], "User approval required");
        }
        super.findPair(ids, coordinates);
        for (int256 ld = 1; ld <= getLDCount(); ld++) {
            Servicelist memory list = getServicelistForLD(ld);
            if (list.allocatedUserIds.length == 0) continue;
            address controller = ldController[ld];
            require(controller != address(0) && participantApproval[controller], "LD approval required");
            for (uint256 j = 0; j < list.allocatedUserIds.length; j++) {
                assignedLD[batchId][list.allocatedUserIds[j]] = ld;
            }
        }
        for (uint256 i = 0; i < ids.length; i++) {
            requestedFiles[batchId][ids[i]] = filenames[i];
            emit ContentRequested(batchId, ids[i], filenames[i]);
        }
    }

}
