/*
 MIT License

 Copyright (c) 2022 Dionysios Karatzas

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import Foundation
import OrderedCollections
import Resolver
import web3

class MainViewModel: ObservableObject {
    private var ethAccount: EthereumAccountProtocol
    private var walletService: WalletServiceProtocol
    @Published var balance = "0.00"
    @Published var state: ViewState = .idle
    @Published var activityList: OrderedSet<ActivityListItemViewModel> = []

    init(ethAccount: EthereumAccountProtocol, walletService: WalletServiceProtocol) {
        self.ethAccount = ethAccount
        self.walletService = walletService
    }

    func fetchAccountBalance() async {
        state = .loading(L10n.loadingBalance)
        let result = await walletService.fetchBalance(for: self.ethAccount.address)
        await MainActor.run {
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

    func sendEthereum() async {
        state = .loading(L10n.sendingEth)
        let result = await walletService.sendEth(walletAddress: AppConstants.walletAddress, tokenAddress: AppConstants.ethAddress, toAddress: AppConstants.toAddress, account: ethAccount, amount: "0.01")
        await MainActor.run {
            switch result {
            case .success(let txHash):
                logger.trace("TxHash: \(txHash)")
                self.state = .idle
                self.fetchTransactionReceipt(for: txHash)
            case .failure(let error):
                logger.warning("\(error)")
                self.state = .failed("\(error)")
            }
        }
    }

    private func fetchTransactionReceipt(for txHash: String) {
        activityList.append(ActivityListItemViewModel(inbound: false, txHash: txHash, status: .notProcessed, amount: "0.01", time: dateNow()))
        Task {
            let result = await walletService.fetchTransactionReceipt(for: txHash)
            await MainActor.run {
                var status: EthereumTransactionReceiptStatus = .notProcessed
                switch result {
                case .success(let receipt):
                    logger.trace("Receipt: \(receipt)")
                    status = receipt.status
                case .failure(let error):
                    logger.warning("\(error)")
                    status = .failure
                }
                self.activityList.updateOrAppend(ActivityListItemViewModel(inbound: false, txHash: txHash, status: status, amount: "0.01", time: self.dateNow()))
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
