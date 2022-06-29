//
//  App+Injection.swift
//  ArgentWallet
//
//  Created by Dionisis Karatzas on 29/6/22.
//

import Foundation
import Resolver
import web3

// swiftlint:disable force_try

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        defaultScope = .graph

        register { URLSessionConfiguration.default }
        register { EthereumClient(url: AppConstants.infuraURL, sessionConfig: resolve()) }.implements(EthereumClientProtocol.self)
        register { try! EthereumAccount.importAccount(keyStorage: EthereumKeyLocalStorage(), privateKey: AppConstants.walletPrivateKey, keystorePassword: AppConstants.keystorePassword) }.implements(EthereumAccountProtocol.self)
        register { WalletService(web3Repository: Web3Repository(), etherscanRepository: EtherscanRepository()) }.implements(WalletServiceProtocol.self)
        register { MainViewModel() }
    }
}
// swiftlint:enable force_try
