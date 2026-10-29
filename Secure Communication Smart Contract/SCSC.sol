// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.21;

// Secure Communication Smart Contract
contract SCSC {
    // R3: AP/operator authorization. The deployer is the initial trusted AP.
    // This is an application role, not a consensus-validator identity.
    address public immutable owner;
    mapping(address => bool) public operators;
    uint256 public batchId;
    event OperatorUpdated(address indexed operator, bool allowed);
    event BatchRecorded(uint256 indexed batch, address indexed operator, uint256 requests);
    event AssignmentRecorded(uint256 indexed batch, int256 indexed userId, int256 indexed LDId);

    modifier onlyOperator() {
        require(operators[msg.sender], "Unauthorized operator");
        _;
    }

    function setOperator(address operator, bool allowed) external {
        require(msg.sender == owner, "Only owner");
        require(operator != address(0), "Zero operator");
        operators[operator] = allowed;
        emit OperatorUpdated(operator, allowed);
    }

    struct User {
        int256 id;
        int256[3] coordinates;
        int256 account;
    }

    struct LD {
        int256 id;
        int256[3] coordinates;
        int256 account;
    }

    struct Pair {
        int256 userId;
        int256 LDId;
    }

    // struct PairResult {
    //     Pair[] pairs;
    //     int256[] unallocatedUsers;
    //     // 其他说明字段...
    // }

    struct PairResult {
        Servicelist Servicelists;
        // 其他字段...
    }

    struct Servicelist{
        int256[] allocatedUserIds;
        int256[3][] userCoordinates; // 用户ID映射到位置信息的映射
        int256[] data;
        int256[] blockid;
    }

    Pair[] public pairs; // 存储配对结果的数组

    mapping(int256 => User) private users;
    mapping(int256 => LD) private LDs;
    mapping(int256 => Servicelist) Servicelists;
    int256 public LDCount; // 用于计数 LD 的数量
    int256 public userCount; // 用于计数用户数量

    int256[] public allocatedUserIds;//已分配User
    int256[] public allocatedLDIds;//已分配LD
    int256[] public unallocatedUserIds;//未分配User

    event Result(Servicelist indexed Servicelists);


    function addUser(int256 userId, int256[3] memory userCoordinates, int256 account) private {
        require(users[userId].id == 0, "User already exists");
        users[userId] = User(userId, userCoordinates, account);
        userCount++; // 增加用户数量
    }

    function addLD(int256 LDId, int256[3] memory LDCoordinates, int256 account) private  {
        require(LDs[LDId].id == 0, "LD already exists");
        LDs[LDId] = LD(LDId, LDCoordinates, account);
        LDCount++; // 增加 LD 的数量
    }

    function updateUserCoordinates(int256 userId, int256[3] memory newCoordinates) private {
        require(users[userId].id != 0, "User does not exist");
        users[userId].coordinates = newCoordinates;
    }

    function initializeServices() internal {
        for (int256 LDId = 1; LDId <= getLDCount(); LDId++) {
            Servicelists[LDId] = Servicelist(new int256[](0), new int256[3][](0),new int256[](0),new int256[](0));
        }
    }

    constructor(){
        owner = msg.sender;
        operators[msg.sender] = true;
        //记录所有LD
        addLD(1, [int256(2), int256(2), int256(3)],0);
        addLD(2, [int256(5), int256(2), int256(3)],0);
        addLD(3, [int256(8), int256(2), int256(3)],0);
        addLD(4, [int256(2), int256(5), int256(3)],0);
        addLD(5, [int256(5), int256(5), int256(3)],0);
        addLD(6, [int256(8), int256(5), int256(3)],0);
        addLD(7, [int256(2), int256(8), int256(3)],0);
        addLD(8, [int256(5), int256(8), int256(3)],0);
        addLD(9, [int256(8), int256(8), int256(3)],0);
        //记录所有User
        //addUser(1, [int256(1), int256(9), int256(1)]);
        //addUser(2, [int256(3), int256(3), int256(1)]);
        //addUser(3, [int256(4), int256(8), int256(1)]);
        //addUser(4, [int256(8), int256(4), int256(1)]);
        //addUser(5, [int256(5), int256(1), int256(1)]);
        //addUser(6, [int256(1), int256(1), int256(1)]);
        //addUser(7, [int256(9), int256(1), int256(1)]);
        //addUser(8, [int256(2), int256(7), int256(1)]);
        //addUser(9, [int256(9), int256(9), int256(1)]);
        //addUser(10, [int256(4), int256(4), int256(1)]);
        //addUser(11, [int256(6), int256(6), int256(1)]);
        //addUser(12, [int256(4), int256(6), int256(1)]);
        //addUser(13, [int256(6), int256(4), int256(1)]);
        //addUser(14, [int256(3), int256(9), int256(1)]);
        //addUser(15, [int256(7), int256(3), int256(1)]);
        //addUser(16, [int256(6), int256(7), int256(1)]);
        //addUser(17, [int256(2), int256(4), int256(1)]);
        //addUser(18, [int256(9), int256(7), int256(1)]);
        //addUser(19, [int256(3), int256(1), int256(1)]);
        //addUser(20, [int256(7), int256(5), int256(1)]);
        //[1,9,1],[3,3,1],[4,8,1],[8,4,1],[5,1,1],[1,1,1],[9,1,1],[2,7,1],[9,9,1],[4,4,1],[6,6,1],[4,6,1],[6,4,1],[3,9,1],[7,3,1],[6,7,1],[2,4,1],[9,7,1],[3,1,1],[7,5,1]
        //但是位置全都未知
        addUser(1, [int256(0), int256(0), int256(0)],1000);
        addUser(2, [int256(0), int256(0), int256(0)],1000);
        addUser(3, [int256(0), int256(0), int256(0)],1000);
        addUser(4, [int256(0), int256(0), int256(0)],1000);
        addUser(5, [int256(0), int256(0), int256(0)],1000);
        addUser(6, [int256(0), int256(0), int256(0)],1000);
        addUser(7, [int256(0), int256(0), int256(0)],1000);
        addUser(8, [int256(0), int256(0), int256(0)],1000);
        addUser(9, [int256(0), int256(0), int256(0)],1000);
        addUser(10, [int256(0), int256(0), int256(0)],1000);
        addUser(11, [int256(0), int256(0), int256(0)],1000);
        addUser(12, [int256(0), int256(0), int256(0)],1000);
        addUser(13, [int256(0), int256(0), int256(0)],1000);
        addUser(14, [int256(0), int256(0), int256(0)],1000);
        addUser(15, [int256(0), int256(0), int256(0)],1000);
        addUser(16, [int256(0), int256(0), int256(0)],1000);
        addUser(17, [int256(0), int256(0), int256(0)],1000);
        addUser(18, [int256(0), int256(0), int256(0)],1000);
        addUser(19, [int256(0), int256(0), int256(0)],1000);
        addUser(20, [int256(0), int256(0), int256(0)],1000);
        //初始化服务列表
        initializeServices();
    }



    function sqrt(int256 x) private pure returns (int256) {
        int256 z = (x + 1) / 2;
        int256 y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
        return y;
    }

    function calculateDistance(int256 userId, int256 LDId) private view returns (int256) {
        User memory user = users[userId];
        LD memory ld = LDs[LDId];
        //int256 distance1 = 0;
        //int256 i = 0;
        //if (i <=2) {
            //int256 d = int256((user.coordinates[i]) - (ld.coordinates[i]));
            //distance1=d*d;
            //i++;
        //}
        //int256 distance1=(ld.coordinates[0]-user.coordinates[0])*(ld.coordinates[0]-user.coordinates[0]);
        //int256 distance2=(ld.coordinates[1]-user.coordinates[1])*(ld.coordinates[1]-user.coordinates[1]);
        //int256 distance3=(ld.coordinates[2]-user.coordinates[2])*(ld.coordinates[2]-user.coordinates[2]);
        int256 distancesum=(ld.coordinates[0]-user.coordinates[0])*(ld.coordinates[0]-user.coordinates[0])+(ld.coordinates[1]-user.coordinates[1])*(ld.coordinates[1]-user.coordinates[1])+(ld.coordinates[2]-user.coordinates[2])*(ld.coordinates[2]-user.coordinates[2]);
        return distancesum;
    }

    function transferAccounts(int256 userId, int256 LDId) internal {
        // 假设转账逻辑已经实现，将100块转给LD
        // 这里需要根据实际情况编写转账逻辑
        // 可以调用其他合约或使用现有的转账功能
        // 以下是示例代码，需要根据具体情况进行修改
        require(users[userId].account >= 100, "Insufficient balance");
        users[userId].account -= 100;
        LDs[LDId].account += 100;
    }

    function findPair(int256[] memory userIds,int256[3][] memory userCoordinates) public virtual onlyOperator {
        require(userIds.length > 0, "Empty user ID array");
        require(userIds.length == userCoordinates.length, "Length mismatch");
        require(userIds.length <= uint256(getUserCount()), "Batch too large");
        // Validate the complete batch before clearing storage. The original
        // ABI and nearest-LD rule are retained; a call still resets the batch.
        for (uint256 i = 0; i < userIds.length; i++) {
            require(users[userIds[i]].id != 0, "Invalid user ID");
            for (uint256 j = 0; j < i; j++) {
                require(userIds[j] != userIds[i], "Duplicate user ID");
            }
            require(userCoordinates[i][0] >= 0 && userCoordinates[i][0] <= 10 &&
                    userCoordinates[i][1] >= 0 && userCoordinates[i][1] <= 10 &&
                    userCoordinates[i][2] >= 0 && userCoordinates[i][2] <= 3,
                    "Outside modeled room");
        }
        require(getLDCount() > 0, "No LDs available for pairing");
        // 清空已分配和未分配组
        clearAllocation();
        //清空服务列表
        clearAllServicelists();

        for (uint256 i = 0; i < userIds.length; i++) {
            int256 userId = userIds[i];
            require(users[userId].id != 0, "Invalid user ID");
            updateUserCoordinates(userId,userCoordinates[i]);

            int256 minDistance = type(int256).max;
            int256 minDistanceLDId;
            int256[3] memory pairedUserCoordinates;

            for (int256 LDId = 1; LDId <= getLDCount(); LDId++) {
                if (LDs[LDId].id == 0) {
                    continue;
                }

                int256 distance = calculateDistance(userId, LDId);
                if (distance < minDistance) {
                    minDistance = distance;
                    minDistanceLDId = LDId;
                    pairedUserCoordinates = users[userId].coordinates;
                }
            }

            require(minDistanceLDId != 0, "No LD found for pairing");

            // bool isAllocated = isLDAllocated(minDistanceLDId);
            // if(!isAllocated){
            //     //将用户放入已分配组
            //     allocatedUserIds.push(userId);
            //     allocatedLDIds.push(minDistanceLDId);
            //     //根据配对结果转账
            //     transferAmount(userId,minDistanceLDId);
            //     //输出配对结果
            //     Pair memory newPair = Pair(userId, minDistanceLDId);
            //     pairs.push(newPair);
            // }
            // else{
            //     // 将用户放入未分配组
            //     unallocatedUserIds.push(userId);
            // }

            // 将用户ID添加到LD的已分配用户列表
            //Servicelists[minDistanceLDId].allocatedUserIds.push(userId);
            // 将用户位置信息添加到LD的已分配用户坐标列表
            //Servicelists[minDistanceLDId].userCoordinates.push(users[userId].coordinates);
            updateServicelists(minDistanceLDId,userId);
            emit AssignmentRecorded(batchId + 1, userId, minDistanceLDId);
        }
        // PairResult  result;
        // // result.pairs = pairs;
        // // result.unallocatedUsers = unallocatedUserIds;
        // result.Servicelists=Servicelists;
        batchId += 1;
        emit BatchRecorded(batchId, msg.sender, userIds.length);
        // The legacy indexed Result struct remains unused; clients retrieve
        // assignments with getServicelistForLD(), using BatchRecorded as a cue.
        //emit Result(Servicelists);
        //return Servicelists;
    }

    function getUserCount() public view returns (int256) {
        return userCount;
    }

    function getLDCount() public view returns (int256) {
        return LDCount;
    }

    function getUserAccount(int256 userId) public view returns (int256) {
        require(users[userId].id != 0, "User does not exist");
        return users[userId].account;
    }

    function getLDAccount(int256 LDId) public view returns (int256) {
        require(LDs[LDId].id != 0, "LD does not exist");
        return LDs[LDId].account;
    }

    function clearAllLDs() private  {
        require(getLDCount() > 0, "No LDs available");

        for (int256 LDId = 1; LDId <= getLDCount(); LDId++) {
            delete LDs[LDId];
        }

        LDCount = 0;
    }

    function clearAllUsers() private  {
        require(getUserCount() > 0, "No users available");

        for (int256 userId = 1; userId <= getUserCount(); userId++) {
            delete users[userId];
        }

        userCount = 0;
    }


    function getServicelistForLD(int256 LDId) public view returns (Servicelist memory) {
        require(LDId >= 1 && LDId <= getLDCount(), "Invalid LDId");
        return Servicelists[LDId];
    }



    function isLDAllocated(int256 LDId) internal view returns (bool) {
        for (uint256 i = 0; i < allocatedLDIds.length; i++) {
            if (allocatedLDIds[i] == LDId) {
                return true;
            }
        }
        return false;
    }

    function clearAllocation() internal {
        delete allocatedUserIds;
        delete allocatedLDIds;
        delete pairs;
        delete unallocatedUserIds;
    }

    function getPairs() public view returns (Pair[] memory) {
        return pairs;
    }

    function getUnallocatedUsers() public view returns (int256[] memory) {
        return unallocatedUserIds;
    }

    //替代式
    // function updateServicelists(int256 LDId, int256 userId) internal {
    //     require(LDId >= 1 && LDId <= getLDCount(), "Invalid LDId");
    //     require(userId >= 1 && userId <= getUserCount(), "Invalid userId");

    //     Servicelist storage serviceList = Servicelists[LDId];

    //     if (serviceList.allocatedUserIds.length >= 3) {
    //         // 删除第一个元素，并将后面的两个元素递进
    //         for (uint256 i = 0; i < 2; i++) {
    //             serviceList.allocatedUserIds[i] = serviceList.allocatedUserIds[i + 1];
    //             serviceList.userCoordinates[i] = serviceList.userCoordinates[i + 1];
    //             serviceList.data[i] = serviceList.data[i + 1];
    //             serviceList.blockid[i] = serviceList.blockid[i + 1];
    //         }

    //         // 删除最后一个元素
    //         serviceList.allocatedUserIds.pop();
    //         serviceList.userCoordinates.pop();
    //         serviceList.data.pop();
    //         serviceList.blockid.pop();
    //     }

    //     // 添加新元素到最后
    //     serviceList.allocatedUserIds.push(userId);
    //     serviceList.userCoordinates.push(users[userId].coordinates);
    //         // 生成随机数并更新 data
    //     int256 randomData = generateRandomData();
    //     serviceList.data.push(randomData);

    //     // 设置 blockid 为当前区块高度
    //     int256 currentBlockNumber = int256(block.number);
    //     serviceList.blockid.push(currentBlockNumber);
    // }

    // R3: batch storage, not a persistent capacity-three FIFO.
    //递增式
    function updateServicelists(int256 LDId, int256 userId) internal {
        require(LDId >= 1 && LDId <= getLDCount(), "Invalid LDId");
        require(userId >= 1 && userId <= getUserCount(), "Invalid userId");

        Servicelist storage serviceList = Servicelists[LDId];

        // 添加新元素到最后
        serviceList.allocatedUserIds.push(userId);
        serviceList.userCoordinates.push(users[userId].coordinates);
        // 生成随机数并更新 data
        int256 randomData = generateRandomData();
        serviceList.data.push(randomData);

        // 设置 blockid 为当前区块高度
        int256 currentBlockNumber = int256(block.number);
        serviceList.blockid.push(currentBlockNumber);
    }


    function generateRandomData() internal view returns (int256) {
        // Legacy display placeholder only: not content, a key, or secure randomness.
        uint256 randomNumber = uint256(keccak256(abi.encodePacked(block.timestamp, blockhash(block.number - 1)))) % 90001 + 10000;
        return int256(randomNumber);
    }

    //清空服务列表
    function clearAllServicelists() internal {
        for (int256 LDId = 1; LDId <= getLDCount(); LDId++) {
            Servicelists[LDId].allocatedUserIds = new int256[](0);
            Servicelists[LDId].userCoordinates = new int256[3][](0);
            Servicelists[LDId].data = new int256[](0);
            Servicelists[LDId].blockid = new int256[](0);
        }
    }
}
