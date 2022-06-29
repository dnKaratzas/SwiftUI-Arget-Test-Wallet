//
//  MainViewModel.swift
//  ArgentWallet
//
//  Created by Dionisis Karatzas on 29/6/22.
//

import Foundation
import Resolver
import web3

class MainViewModel: ObservableObject {
    @Injected private var ethAccount: EthereumAccountProtocol
    @Injected private var walletService: WalletServiceProtocol
    @Published var balance = "0.00"
    @Published var state: ViewState = .idle

    func fetchAccountBalance() {
        self.state = .failed(L10n.genericSystemError)

        walletService.fetchBalance(for: ethAccount.address) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let balance):
                    self.balance = balance
                    self.state = .idle
                case .failure(let error):
                    logger.warning("\(error)")
                    self.state = .failed(L10n.genericSystemError)
                }
            }
        }
    }
}
