// Generated using TezosGen

import TezosSwift
import Combine

struct ContractMethodInvocation {
    private let send: (_ from: Wallet, _ amount: TezToken, _ operationFees: OperationFees?, _ completion: @escaping RPCCompletion<String>) -> Cancelable?

    init(send: @escaping (_ from: Wallet, _ amount: TezToken, _ operationFees: OperationFees?, _ completion: @escaping RPCCompletion<String>) -> Cancelable?) {
        self.send = send
    }

    func send(from: Wallet, amount: TezToken, operationFees: OperationFees? = nil, completion: @escaping RPCCompletion<String>) -> Cancelable? {
        self.send(from, amount, operationFees, completion)
    }
    
    func sendPublisher(from: Wallet, amount: TezToken, operationFees: OperationFees? = nil) -> ContractPublisher<String> {
        ContractPublisher(send: { self.send(from, amount, operationFees, $0) })
    }
}
