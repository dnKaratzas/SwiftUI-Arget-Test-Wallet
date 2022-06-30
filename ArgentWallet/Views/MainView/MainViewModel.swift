//
//  MainViewModel.swift
//  ArgentWallet
//
//  Created by Dionisis Karatzas on 29/6/22.
//

import Foundation
import OrderedCollections
import Resolver
import web3

class MainViewModel: ObservableObject {
    @Injected private var ethAccount: EthereumAccountProtocol
    @Injected private var walletService: WalletServiceProtocol
    @Published var balance = "0.00"
    @Published var state: ViewState = .idle
    @Published var activityList: OrderedSet<ActivityListItemViewModel> = []

    func fetchAccountBalance() {
        state = .loading("Fetching Balance...")

        walletService.fetchBalance(for: ethAccount.address) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let balance):
                    self?.balance = balance
                    self?.state = .idle
                case .failure(let error):
                    logger.warning("\(error)")
                    self?.state = .failed(L10n.genericSystemError)
                }
            }
        }
    }

    func sendEthereum() {
        state = .loading("Sending 0.01 Eth...")

        walletService.sendEth(walletAddress: AppConstants.walletAddress, tokenAddress: AppConstants.ethAddress, toAddress: AppConstants.toAddress, account: ethAccount, amount: "0.01") { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let txHash):
                    logger.trace("TxHash: \(txHash)")
                    self?.state = .idle
                    self?.fetchTransactionReceipt(for: txHash)
                case .failure(let error):
                    logger.warning("\(error)")
                    self?.state = .failed("\(error)")
                }
            }
        }
    }

    private func fetchTransactionReceipt(for txHash: String) {
        activityList.append(ActivityListItemViewModel(inbound: false, txHash: txHash, status: .notProcessed, amount: "0.01", time: dateNow()))

        walletService.fetchTransactionReceipt(for: txHash) { [weak self] result in
            DispatchQueue.main.async {
                var status: EthereumTransactionReceiptStatus = .notProcessed
                switch result {
                case .success(let receipt):
                    logger.trace("Receipt: \(receipt)")
                    status = receipt.status
                case .failure(let error):
                    logger.warning("\(error)")
                    status = .failure
                }
                self?.activityList.updateOrAppend(ActivityListItemViewModel(inbound: false, txHash: txHash, status: status, amount: "0.01", time: self?.dateNow() ?? ""))
                print()
            }
        }
    }

    private func dateNow() -> String {
        let today = Date.now
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .short
        return formatter1.string(from: today)
    }
}
