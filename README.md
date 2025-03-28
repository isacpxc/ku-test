# KU Test

## 1 - Section 1: Knowledge and Fundamentals (Answers)

### 1. Describe the various consensus mechanisms used in blockchain networks (e.g., Proof of Work, Proof of Stake, Delegated Proof of Stake) and discuss their advantages and disadvantages.

Blockchain networks need a way to agree on which transactions are legit (consensus). Here are the big three methods:

#### Proof of Work (PoW) – The OG (Bitcoin’s Choice)
**How it works:** Miners solve crazy-hard math puzzles to add blocks. First to solve it wins crypto.

- **Pros:** Super secure (hard to attack), truly decentralized.
- **Cons:** Wastes tons of electricity, slow, needs expensive GPUs.


#### Delegated Proof of Stake (DPoS) – The Democracy Model (EOS, Tron)
**How it works:** Token holders vote for a few "delegates" who validate transactions for everyone.

- **Pros:** Super fast, scalable, feels kinda democratic.
- **Cons:** Small group of delegates = risk of centralization, voters need to stay active.

#### Proof of Stake (PoS) – The Energy-Saver (Ethereum’s New Upgrade)
**How it works:** Validators "stake" their own crypto to get picked to validate blocks. More stake = higher chance.

- **Pros:** Way greener, faster, cheaper to run.
- **Cons:** Rich get richer (more stake = more power), can lead to centralization.


### 2. Identify and explain at least three common security vulnerabilities associated with smart contracts. Describe strategies or best practices you would implement to mitigate these risks.

* Reentrancy Attacks: Occur when a malicious contract repeatedly calls a function in the target contract before the previous execution is complete.

    * Mitigation: Implement checks-effects-interactions patterns and use reentrancy guards. **Example of use:** OpenZeppelin’s ReentrancyGuard.

* Integer Overflow/Underflow: These vulnerabilities arise when calculations exceed or fall below the allowable range. **example**: uint256 hits max and flips to 0

    * Mitigation: Use safe math libraries like OpenZeppelin to handle arithmetic operations securely. 

* Access Control Issues: Poorly designed access controls can allow unauthorized parties to manipulate contract functions.

    * Mitigation: Implement authorization mechanisms and role-based access controls.
    
### 3. Explain the concept of metadata in NFTs. How does metadata enhance the value of an NFT, and what best practices should be followed in storing and managing NFT metadata?

* NFT Metadata It’s the "data about data" – the name, description, image URL, traits, etc., that make your NFT unique.  
    * Example: Bored Ape #1234 has metadata saying it’s a "Gold Fur Ape with a Sailor Hat." This is important because for example, rare features of a KU in the KUverse = higher value.
 
* Best Practices for Storing Metadata: On-Chain (Best but Expensive): Store everything directly in the contract (fully decentralized). IPFS/Arweave (Most Common): Store metadata in decentralized storage (cheaper, still secure). Avoid Centralized Servers: If your HTTP link dies, your NFT becomes a blank picture.

 

Use of OpenZeppelin’s `ERC721URIStorage` for flexible metadata handling is a great idea!

## 2 - Section 2: Practical Coding Challenge

1. Task: Write a simple ERC-721 smart contract for an NFT collection. The contract should include functionality for minting, transferring, and querying ownership. Ensure to implement basic security best practices.
Requirements:
Include a function that allows users to mint a new NFT with metadata (name, description, image URL).
Ensure proper access controls and event emissions.

* contract on `MyNFTCollection.sol`.

2. Code Review:
Task: Analyze the following code snippet for vulnerabilities and inefficiencies. Suggest improvements and explain your rationale.
  ```solidity
  function transfer(address _to, uint256 _tokenId) public {
       require(ownerOf(_tokenId) == msg.sender, "Not the owner");
       owners[_tokenId] = _to;
   }
```

* It fails to emit events after transferring ownership, reducing transparency for tools like blockchain explorers. Direct modification of the owners mapping bypasses key checks required for ERC-721 compliance, and the absence of input validation for the _to address risks transferring tokens to invalid addresses, potentially causing irrecoverable losses.  Lastly, it does not adhere to ERC-721 standards by omitting safeTransferFrom, which ensures compatibility with token-aware smart contracts.

* refactored version of the function:
```solidity
function transfer(address _to, uint256 _tokenId) public whenNotPaused {
    // Validate ownership and recipient address
    require(ownerOf(_tokenId) == msg.sender, "Not the owner");
    require(_to != address(0), "Invalid recipient address");

    // Update ownership using standard ERC-721 function
    _safeTransfer(msg.sender, _to, _tokenId, "");

    // Emit the Transfer event
    emit Transfer(msg.sender, _to, _tokenId);
}
```

3. Deployment:
Provide a brief guide on how to deploy your smart contract to a test network (e.g., Rinkeby or Kovan). Include any necessary configurations and commands.



---

### Step-by-Step Guide for Deploying on the Sepolia Testnet

1. **Set Up MetaMask**:
   - Install the MetaMask browser extension from [here](https://metamask.io/download).
   - Create a new wallet or import an existing one.
   - Add the Sepolia network manually:
     - this can be done by enabling testnets in metamask as in this [video](https://www.youtube.com/watch?v=H8aL1yXPVho&ab_channel=TechTraverseTips).   

2. **Get Sepolia Test ETH**:
   - Visit a Sepolia faucet, such as the [Alchemy Faucet](https://cloud.google.com/application/web3/faucet/ethereum/sepolia), and request test ETH. This is used to pay for gas fees during deployment.

3. **Access Remix IDE**:
   - Open [Remix IDE](https://remix.ethereum.org/) in your browser.
   - Click in _Open a File From Your File System_ icon, and import `MyNFTCollection.sol`.

4. **Compile Your Contract**:
   - Navigate to the **Solidity Compiler** tab in Remix.
   - Ensure the compiler version(`0.8.20`) matches the one specified in your contract (`pragma solidity`).
   - Click **Compile MyContract.sol**.

5. **Deploy Your Contract**:
   - Open the **Deploy & Run Transactions** tab.
   - In the *Environment* dropdown, choose **Injected Provider - MetaMask** (this connects Remix to your MetaMask wallet).
   - Make sure MetaMask is set to the Sepolia network.
   - Fill in the address of the owner of the contract for the Constructor and **Deploy** and confirm the transaction in MetaMask.

6. **Interact with Your Contract**:
   - After deployment, your contract will appear under **Deployed Contracts** in Remix.
   - Use the interface to call functions and interact with your contract.



## 3 - Section 1: Knowledge and Fundamentals (Answers)

1. Scenario: Task: Your team is facing performance issues with the current smart contracts due to high gas fees during minting. How would you address this problem? What optimizations would you consider?

To lower gas fees during minting, simplify the smart contract by reducing operations and complexity. Mint tokens only when needed (lazy minting) and combine multiple actions into one transaction to save costs. Move non-essential data to decentralized storage like IPFS or Arweave and use optimized Solidity coding techniques. Switching to Layer 2 solutions like Polygon or more efficient standards like ERC-1155 can also help cut fees.

2. Discuss a challenging blockchain project you have worked on. What were the main hurdles, and how did you resolve them?


One of the most challenging blockchain projects I tackled was "Token Book," a digital library powered by Ethereum and smart contracts like `LibAccess.sol`. The system needed a secure and efficient way to manage access to digital books.

A key challenge was ensuring the proper implementation of book ownership and access control. The `LibAccess.sol` contract had to efficiently map ownership and permissions for each book using functions like `addBook`, `grantAccess`, and `revokeAccess`. We resolved this by using mappings, modifiers for role-based access, and robust error handling to ensure only the rightful owners could manage books.

Another hurdle was the integration of decentralized storage through Pinata for metadata. Configuring and securing the GATEWAY and JWT in the `.env` file was crucial to keeping the system functional and secure.

To address these issues, we focused on precise implementation of smart contract logic, comprehensive testing, and detailed configuration guidelines. These measures ensured Token Book operated securely and smoothly, while adhering to the principles of decentralization.

In another project, I built a blockchain system in C with cryptographic hashing and a simple GUI. Challenges included ensuring secure SHA-256 hashing for blocks and transactions, managing memory efficiently, and making the setup user-friendly across platforms like Windows. To tackle these, I used OpenSSL for secure hashing, rigorously tested memory management, and created clear documentation for environment setup and usage. The result was a streamlined and interactive blockchain implementation.

