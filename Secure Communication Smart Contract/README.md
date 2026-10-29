# Ethereum contract and application

`STSC.sol` is the filename-aware B-HLW workflow entry point. Its inherited allocator in `SCSC.sol` retains the original nine-LD/twenty-user example and ascending-ID nearest-distance scan. The two-array `SCSC.findPair` interface is retained for exact reproduction of the response's gas table.

## Compile and test

From the repository root:

```powershell
npm.cmd ci --ignore-scripts
npm.cmd run compile
python verification/verify_policy.py
node "Secure Communication Smart Contract/verify_contract.cjs"
node "Secure Communication Smart Contract/test_workflow.cjs"
```

Compilation exports ABI and bytecode to `artifacts/`. The legacy-ABI verifier runs eighteen checks and sixteen gas/calldata measurements. The workflow test exercises the actual compiled `STSC` with separate local wallets and an encrypted payload receiver. Results are saved under `results/` in this directory. Ganache uses its JavaScript transport fallback for the in-process test provider.

## Remix and Testnet steps

1. Import `SCSC.sol` and `STSC.sol` into the same Remix workspace directory. Select Solidity 0.8.21, optimizer enabled with 200 runs, and EVM target Paris, matching `compile.cjs`.
2. Connect the AP's MetaMask wallet to the selected Testnet and select Remix's injected wallet provider. Deploy `STSC`. The AP/deployer signs this creation transaction; the constructor initializes the example instance. Record the contract address, deployment transaction and compiled ABI.
3. The owner enrolls the AP account with `setOperator`, user accounts with `setUserSigner`, and LD controller accounts with `setLDController`. Each participating account signs its own `approveParticipation(true)` call. These application approvals are separate transactions, as in the case-study and Supplementary workflow.
4. For a batch, the AP calls `findPair(int256[],int256[3][],string[])` with IDs, integer-metre coordinates and filenames. For example, `[1,2]`, `[[2,2,1],[5,2,1]]`, and `["example.bin","example.bin"]`. The address enrolled for each user and assigned LD must have approved participation.
5. Inspect `BatchRecorded`, `AssignmentRecorded` and `ContentRequested` in the receipt. Read the current batch through `getServicelistForLD`. Retrieve filename history through `requestedFiles(batch,userId)`.
6. The application applies persistent-queue admission and informs rejected users. After the configured number of subsequent blocks, the LD transport sends the authenticated, encrypted file selected by the request. The user returns a request-bound ACK over the control interface; a valid ACK releases the queue head.

[Ethereum's network documentation](https://ethereum.org/developers/docs/networks/) identifies Sepolia as its application-development Testnet. AP/user/LD wallets are application participants; Ethereum's network supplies the validator set. The service list uses contract storage, and batch outcomes use receipt events. The contract preserves batch reset, while the application keeps unfinished queues across batches.

## Application interface

`ServiceApplication` accepts an ethers contract connected to the AP signer, a durable `stateFile`, a `contentRoot`, a per-user filename ACL, and a 32-byte payload key per user. Keys are supplied through the deployment's protected key-management interface and stay outside transactions and queue files. The included tests generate ephemeral local keys.

`signRequest` signs a request containing `chainId`, `contract`, `userId`, `position`, `filename`, `nonce` and `expires`. `submitBatch` validates the complete batch, records its broadcast hash, waits for inclusion and commits application admission. `recoverPending` resumes a broadcast transaction journal. `serveNext(ld, receiver)` gates service by canonical block/confirmation checks, reads the permitted file, and sends an AES-GCM packet through the receiver callback. `receive` authenticates/decrypts the packet and returns the plaintext and ACK.

Run one AP state writer for a given `stateFile`. Preserve the state file and payload keys when restarting. Submitted IDs/coordinates/filenames and allocation receipts are public control metadata; file payloads and encryption keys use the application transport. The off-chain decision log retains each signed request for authorized audit.
