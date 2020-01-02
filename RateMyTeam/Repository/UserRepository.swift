//
//  UserRepository.swift
//  RateMyTeam
//
//  Created by Marek Fořt on 12/16/19.
//  Copyright © 2019 Marek Fořt. All rights reserved.
//

import Foundation
import Combine
import TezosSwift

struct UserRepositoryState {
    var wallet: Wallet?
}

enum UserRepositoryInput {
    case addWallet(secretKey: String)
    case deleteWallet
}

protocol HasUserRepository {
    var userRepository: AnyRepository<UserRepositoryState, UserRepositoryInput> { get }
}

final class UserRepository: Repository {
    typealias Dependencies = HasNoDependency
    
    @Published var state: UserRepositoryState
    
    init(dependencies: Dependencies) {
        let wallet = UserRepository.findWallet()
        state = UserRepositoryState(wallet: wallet)
    }
    
    func trigger(_ input: UserRepositoryInput) {
        switch input {
        case let .addWallet(secretKey: secretKey):
            state.wallet = Wallet(secretKey: secretKey)
           
            let password = secretKey.data(using: String.Encoding.utf8)!
            let query: [String: Any] = [kSecClass as String: kSecClassKey,
                                        kSecAttrApplicationTag as String: "tezos",
                                        kSecValueData as String: password]
            let status = SecItemAdd(query as CFDictionary, nil)
            guard status == errSecSuccess else { return }
        case .deleteWallet:
            removeWallet()
        }
    }
    
    // MARK: - Helpers
    
    private static func findWallet() -> Wallet? {
        let query: [String: Any] = [kSecClass as String: kSecClassKey,
                                    kSecAttrApplicationTag as String: "tezos",
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnAttributes as String: true,
                                    kSecReturnData as String: true]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else { return nil }
        guard status == errSecSuccess else { return nil }
        
        guard let existingItem = item as? [String : Any],
            let secretKeyData = existingItem[kSecValueData as String] as? Data,
            let secretKey = String(data: secretKeyData, encoding: .utf8)
        else {
            return nil
        }
        return Wallet(secretKey: secretKey)
    }
    
    private func removeWallet() {
        let query: [String: Any] = [kSecClass as String: kSecClassKey,
                                    kSecAttrApplicationTag as String: "tezos"]
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else { return }
        state.wallet = nil
    }
}
