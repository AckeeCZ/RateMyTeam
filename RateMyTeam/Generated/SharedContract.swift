// Generated using TezosGen

import TezosSwift
import Combine

struct ContractMethodInvocation {
    fileprivate let send: (_ from: Wallet, _ amount: TezToken, _ operationFees: OperationFees?, _ completion: @escaping RPCCompletion<String>) -> Cancelable?

    init(send: @escaping (_ from: Wallet, _ amount: TezToken, _ operationFees: OperationFees?, _ completion: @escaping RPCCompletion<String>) -> Cancelable?) {
        self.send = send
    }

    func send(from: Wallet, amount: TezToken, operationFees: OperationFees? = nil, completion: @escaping RPCCompletion<String>) -> Cancelable? {
        self.send(from, amount, operationFees, completion)
    }
        
    func sendPublisher(from: Wallet, amount: TezToken, operationFees: OperationFees? = nil) -> ContractPublisher {
        ContractPublisher(send: { self.send(from, amount, operationFees, $0) })
    }
}

typealias SendMethod = (@escaping RPCCompletion<String>) -> Cancelable?

class ContractSubscription<S: Subscriber>: Subscription where S.Input == String, S.Failure == TezosError {
    private let send: SendMethod
    private var hasValue = true
    private var cancelable: Cancelable?
    private var cancellable: Cancellable?
    private var subscriber: S
    
    init(subscriber: S, send: @escaping SendMethod) {
        self.subscriber = subscriber
        self.send = send
    }
    
    func request(_ demand: Subscribers.Demand) {
        guard hasValue else { return }
        cancellable = Future { [weak self] promise in
            self?.cancelable = self?.send(promise)
        }.sink(receiveCompletion: { [weak self] in
            self?.subscriber.receive(completion: $0)
        }, receiveValue: { [weak self] in
            _ = self?.subscriber.receive($0)
        })
    }
    
    func cancel() {
        cancelable?.cancel()
        cancellable?.cancel()
    }
}

struct ContractPublisher: Publisher {
    typealias Output = String
    typealias Failure = TezosError
    
    private let send: SendMethod
    
    init(send: @escaping SendMethod) {
        self.send = send
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        let subscription = ContractSubscription(subscriber: subscriber, send: send)
        subscriber.receive(subscription: subscription)
    }
}