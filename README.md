# ERC20 Airdrop contract

This project demonstrates a way to airdrop ERC20 Tokens

Try running some of the following tasks:


```shell
npx hardhat accounts
npx hardhat compile
npx hardhat clean
npx hardhat test
npx hardhat node
npx hardhat help
REPORT_GAS=true npx hardhat test
npx hardhat coverage
npx hardhat run scripts/deploy.js
```

# HOW TO USE

```shell
Constructor takes two arguments:
-- Token address
-- Address of payer where the ERC1155 tokens are present

addAirDrops function Takes two args:
-- _candidates - This is array of candidates where Tokens are to be airdroppped
-- _NFTIs - Array of amount of Tokens that needs be airdropped to candidates

airDropTokens function will airdrop only ONE Tokens to particular account

batchAirDropTokens function: As the name suggests, this will airdrop only ONE Tokens to array of account

airDropToAllEligible function will airdrop ONE Tokens to all account who is eligble for airdrop.
```
