//
//  WalletService.swift
//  ArgentWallet
//
//  Created by Dionisis Karatzas on 29/6/22.
//

import BigInt
import Foundation
import web3

protocol WalletServiceProtocol {
    /// Returns the ETH balance, formatted to 2 decimals
    func fetchBalance(for address: EthereumAddress, completion: @escaping (Result<String, Error>) -> Void)
    /// Returns a list of all received ERC20 transfers for the Argent wallet.
    func sendEth(walletAddress: EthereumAddress, tokenAddress: EthereumAddress, toAddress: EthereumAddress, account: EthereumAccountProtocol, amount: String, completion: @escaping (Result<String, Error>) -> Void)

    func fetchTransactionReceipt(for txHash: String, completion: @escaping (Result<EthereumTransactionReceipt, Error>) -> Void)
}

struct WalletService: WalletServiceProtocol {
    private var web3Repository: Web3Repository
    private var etherscanRepository: EtherscanRepository

    init(web3Repository: Web3Repository, etherscanRepository: EtherscanRepository) {
        self.web3Repository = web3Repository
        self.etherscanRepository = etherscanRepository
    }

    func fetchBalance(for address: EthereumAddress, completion: @escaping (Result<String, Error>) -> Void) {
        Task {
            do {
                let balance = try await web3Repository.fetchBalance(for: address)

                guard let balanceStr = Web3.Utils.formatToEthereumUnits(balance, toUnits: .eth),
                      let balanceDouble = Double(balanceStr)?.rounded(2) else {
                    completion(.failure("Failed to formatToEthereumUnits balance: \(balance)"))
                    return
                }
                completion(.success(String(balanceDouble)))
            } catch {
                completion(.failure("\(error)"))
            }
        }
    }

    func sendEth(walletAddress: EthereumAddress, tokenAddress: EthereumAddress, toAddress: EthereumAddress, account: EthereumAccountProtocol, amount: String, completion: @escaping (Result<String, Error>) -> Void) {
        Task {
            do {
                let txHash = try await web3Repository.sendEth(walletAddress: walletAddress, tokenAddress: tokenAddress, toAddress: toAddress, account: account, amount: amount)

                completion(.success(txHash))
            } catch {
                completion(.failure("\(error)"))
            }
        }
    }

    func fetchTransactionReceipt(for txHash: String, completion: @escaping (Result<EthereumTransactionReceipt, Error>) -> Void) {
        Task {
            do {
                let receipt = try await web3Repository.fetchTransactionReceipt(for: txHash)

                completion(.success(receipt))
            } catch {
                completion(.failure("\(error)"))
            }
        }
    }
}
