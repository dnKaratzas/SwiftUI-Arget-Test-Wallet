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

import BigInt
import Foundation
import web3

protocol WalletServiceProtocol {
    /// Returns the ETH balance, formatted to 2 decimals
    func fetchBalance(for address: EthereumAddress) async -> Result<String, Error>
    /// Returns a list of all received ERC20 transfers for the Argent wallet.
    func sendEth(walletAddress: EthereumAddress, tokenAddress: EthereumAddress, toAddress: EthereumAddress, account: EthereumAccountProtocol, amount: String) async -> Result<String, Error>

    func fetchTransactionReceipt(for txHash: String) async -> Result<EthereumTransactionReceipt, Error>

    func fetchERC20Transfers() async -> Result<[ERC20Transfer], Error>
}

struct WalletService: WalletServiceProtocol {
    private var web3Repository: Web3Repository
    private var etherscanRepository: EtherscanRepository

    init(web3Repository: Web3Repository, etherscanRepository: EtherscanRepository) {
        self.web3Repository = web3Repository
        self.etherscanRepository = etherscanRepository
    }

    func fetchBalance(for address: EthereumAddress) async -> Result<String, Error> {
        do {
            let balance = try await web3Repository.fetchBalance(for: address)

            guard let balanceStr = Web3.Utils.formatToEthereumUnits(balance, toUnits: .eth),
                  let balanceDouble = Double(balanceStr)?.rounded(2) else {
                return .failure("Failed to formatToEthereumUnits balance: \(balance)")
            }
            return .success(String(balanceDouble))
        } catch {
            return .failure("\(error)")
        }
    }

    func sendEth(walletAddress: EthereumAddress, tokenAddress: EthereumAddress, toAddress: EthereumAddress, account: EthereumAccountProtocol, amount: String) async -> Result<String, Error> {
        do {
            let txHash = try await web3Repository.sendEth(walletAddress: walletAddress, tokenAddress: tokenAddress, toAddress: toAddress, account: account, amount: amount)

            return .success(txHash)
        } catch {
            return .failure("\(error)")
        }
    }

    func fetchTransactionReceipt(for txHash: String) async -> Result<EthereumTransactionReceipt, Error> {
        do {
            guard let receipt = try await web3Repository.fetchTransactionReceipt(for: txHash) else {
                throw "Failed to fetch receipt for tx: \(txHash)"
            }

            return .success(receipt)
        } catch {
            return .failure("\(error)")
        }
    }

    func fetchERC20Transfers() async -> Result<[ERC20Transfer], Error> {
        do {
            let result = try await etherscanRepository.fetchERC20Transfers()

            return .success(result.transfers)
        } catch {
            return .failure("\(error)")
        }
    }
}
