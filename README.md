# Land Registry (Blockchain College Project)

A simple land registration system built with **Solidity + Hardhat**, with a
plain HTML/JS frontend that talks to the contract through **MetaMask**.

Each land record stores:
- **Name** — owner's name
- **Age** — owner's age
- **History** — free-text description/history of the land
- **UID** — a unique ID used to look the record back up

Records can never overwrite each other (the contract rejects a duplicate UID),
so every land added shows up in the running list — this is what the "View
Blockchain" button displays.

## Project structure

```
land-registry/
├── contracts/
│   └── LandRegistry.sol     # The smart contract
├── scripts/
│   └── deploy.js            # Deploys the contract to a local network
├── frontend/
│   └── index.html           # The UI (register / search / view all)
├── hardhat.config.js
└── package.json
```

## 1. Install dependencies

You need [Node.js](https://nodejs.org/) installed. Then, inside the project folder:

```bash
npm install
```

## 2. Start a local blockchain

In one terminal, run a local Hardhat network (this simulates a blockchain
with test accounts and fake ETH):

```bash
npx hardhat node
```

Leave this running — it's your local blockchain for the demo.

## 3. Deploy the contract

In a **second terminal**:

```bash
npx hardhat run scripts/deploy.js --network localhost
```

This prints something like:

```
LandRegistry deployed to: 0x5FbDB2315678afecb367f032d93F642f64180aa3
```

Copy that address.

## 4. Connect the frontend

Open `frontend/index.html` in a text editor and paste the deployed address
into this line near the top of the `<script>` section:

```js
const CONTRACT_ADDRESS = "PASTE_DEPLOYED_CONTRACT_ADDRESS_HERE";
```

Save the file.

## 5. Set up MetaMask to talk to your local chain

1. Install the [MetaMask](https://metamask.io/) browser extension if you don't have it.
2. Add a new network in MetaMask:
   - Network name: `Hardhat Local`
   - RPC URL: `http://127.0.0.1:8545`
   - Chain ID: `31337`
   - Currency symbol: `ETH`
3. Import a test account: copy one of the private keys printed by `npx hardhat node`
   (in the first terminal) into MetaMask via **Import Account**. This gives you
   a wallet pre-loaded with fake test ETH so you can pay gas on your local chain.

## 6. Open the app

Just open `frontend/index.html` directly in your browser (double-click it, or
right-click → Open With → your browser). Click **Connect Wallet**, approve the
MetaMask popup, and you're live.

- **Register a Land** — fill in the form and submit. MetaMask will ask you to
  confirm the transaction.
- **Search by UID** — type a UID and click Search to pull up that one record.
- **View Blockchain** — lists every land ever registered, newest logic aside,
  in the order they were added.

## Notes for your presentation

- The contract enforces that a UID can only be registered once (`require(!lands[_uid].exists, ...)`),
  which is what makes this "immutable" in the blockchain sense — records
  can't be silently overwritten, only added.
- `registeredBy` and `timestamp` are captured automatically from the blockchain
  itself (`msg.sender` and `block.timestamp`), so every record is
  cryptographically tied to who submitted it and when — you don't need to
  collect that from the user.
- For a live/public demo instead of a local network, you can deploy the same
  contract to a testnet like Sepolia by adding a network entry to
  `hardhat.config.js` and funding your wallet with free testnet ETH from a
  faucet.
