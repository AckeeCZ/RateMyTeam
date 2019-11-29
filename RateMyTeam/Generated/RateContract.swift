// Generated using TezosGen
// swiftlint:disable file_length

import Foundation
import TezosSwift

/// Struct for function currying
struct RateContractBox {
    fileprivate let tezosClient: TezosClient
    fileprivate let at: String

    fileprivate init(tezosClient: TezosClient, at: String) {
       self.tezosClient = tezosClient
       self.at = at
    }
    /**
     Call RateContract with specified params.
     **Important:**
     Params are in the order of how they are specified in the Tezos structure tree
    */
    func end() -> ContractMethodInvocation {
        let send: (_ from: Wallet, _ amount: TezToken, _ operationFees: OperationFees?, _ completion: @escaping RPCCompletion<String>) -> Cancelable?
        send = { from, amount, operationFees, completion in
            self.tezosClient.send(amount: amount, to: self.at, from: from, operationFees: operationFees, completion: completion)
        }

        return ContractMethodInvocation(send: send)
    }

    /**
     Call RateContract with specified params.
     **Important:**
     Params are in the order of how they are specified in the Tezos structure tree
    */
    func vote(_ param1: String) -> ContractMethodInvocation {
        let send: (_ from: Wallet, _ amount: TezToken, _ operationFees: OperationFees?, _ completion: @escaping RPCCompletion<String>) -> Cancelable?
        let input: String = param1
        send = { from, amount, operationFees, completion in
            self.tezosClient.send(amount: amount, to: self.at, from: from, input: input, operationFees: operationFees, completion: completion)
        }

        return ContractMethodInvocation(send: send)
    }

    /// Call this method to obtain contract status data
    @discardableResult
    func status(completion: @escaping RPCCompletion<RateContractStatus>) -> Cancelable? {
        let endpoint = "/chains/main/blocks/head/context/contracts/" + at
        return tezosClient.sendRPC(endpoint: endpoint, method: .get, completion: completion)
    }
}

/// Status data of RateContract
struct RateContractStatus: Decodable {
    /// Balance of RateContract in Tezos
    let balance: Tez
    /// Is contract spendable
    let spendable: Bool
    /// RateContract's manager address
    let manager: String
    /// RateContract's delegate
    let delegate: StatusDelegate
    /// RateContract's current operation counter
    let counter: Int
    /// RateContract's storage
    let storage:RateContractStatusStorage

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ContractStatusKeys.self)
        self.balance = try container.decode(Tez.self, forKey: .balance)
        self.spendable = try container.decode(Bool.self, forKey: .spendable)
        self.manager = try container.decode(String.self, forKey: .manager)
        self.delegate = try container.decode(StatusDelegate.self, forKey: .delegate)
        self.counter = try container.decodeRPC(Int.self, forKey: .counter)

        let scriptContainer = try container.nestedContainer(keyedBy: ContractStatusKeys.self, forKey: .script)
        self.storage = try scriptContainer.decode(RateContractStatusStorage.self, forKey: .storage)
    }
}
/**
 RateContract's storage with specified args.
 **Important:**
 Args are in the order of how they are specified in the Tezos structure tree
*/
struct RateContractStatusStorage: Decodable {
    let ballot: [(String, UInt)]
	let hasEnded: Bool
	let master: String
	let totalNumberOfVotes: UInt
	let voters: [(String, Int)]

    public init(from decoder: Decoder) throws {
        let tezosElement = try decoder.singleValueContainer().decode(TezosPair<TezosPair<TezosPair<TezosPair<TezosMap<String, UInt>, Bool>, String>, UInt>, TezosMap<String, Int>>.self)

        self.ballot = tezosElement.first.first.first.first.pairs.map { ($0.first, $0.second) }
		self.hasEnded = tezosElement.first.first.first.second
		self.master = tezosElement.first.first.second
		self.totalNumberOfVotes = tezosElement.first.second
		self.voters = tezosElement.second.pairs.map { ($0.first, $0.second) }
    }
}

extension TezosClient {
    /**
     This function returns type that you can then use to call RateContract specified by address.

     - Parameter at: String description of desired address.

     - Returns: Callable type to send Tezos with.
    */
    func rateContract(at: String) -> RateContractBox {
        return RateContractBox(tezosClient: self, at: at)
    }
}