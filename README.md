# RateMyTeam

RateMyTeam is a PoC demonstrating the abilites of Tezos smart contracts and our tools [tezosgen](https://github.com/AckeeCZ/tezosgen/) and [TezosSwift](https://github.com/AckeeCZ/TezosSwift). RateMyTeam solves the following problem: every year we distribute bonuses to the various teams of our company. To make this process transparent, every team member would get a limited number of votes that can be casted to whichever team they felt like performed the best that year. When the vote ends, all tokens from the contract are distributed to the candidates depending on how many votes they have received during the voting process. But this voting process can be expanded to many other use cases, so feel free to experiment with it 🙂

This app, as it is a PoC, runs on Carthagenet - that means that do expect that contracts that you use will be deleted eventually.

The easiest way to get yourself up and running with your contracts are the following steps:

1. Go to https://smartpy.io/demo/faucetImporter.html
2. After you download data from the Faucet, copy your private key (this key will be then used to sign you in the app!)
3. Change the node to https://rpcalpha.tzbeta.net/
4. Leave protocol to Babylon, activate account and when it is included in the network, reveal it
5. Go to https://smartpy.io/test2/
6. Paste the contract code from the root folder of this repo in `contract.py` file
7. Edit addresses to your desired ones (`addr4` is a master that can end the vote, `addr5` and `addr6` are votes - you probably want your new account to be in these addresses, other addresses will appear on the ballot)
8. Run the code, change to `Michelson` tab and hit deploy contract
9. Paste your private key, change the node again to https://rpcalpha.tzbeta.net/
10. Type in the amount you want for your contract (generally it is good to go over the below gas limit in order for the contract to work properly)
11. Deploy contract
12. Open RateMyTeam app, paste in your private key, hit plus button and paste in the address of the originated contract
13. Vote and have fun!

To build this app, first clone this repository and then run `pod install`. After you open Xcode, you should be able to build the app.