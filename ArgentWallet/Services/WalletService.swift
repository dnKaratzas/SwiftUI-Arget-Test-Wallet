//
//  WalletService.swift
//  ArgentWallet
//
//  Created by Dionisis Karatzas on 29/6/22.
//

import Foundation
import web3

protocol WalletServiceProtocol {
    /// Returns the ETH balance, formatted to 2 decimals
    func fetchBalance(for address: EthereumAddress, completion: @MainActor @escaping (Result<String, Error>) -> Void)
    /// Returns a list of all received ERC20 transfers for the Argent wallet.
    func fetchERC20InboundTransfers() async throws
}

struct WalletService: WalletServiceProtocol {
    private var web3Repository: Web3Repository
    private var etherscanRepository: EtherscanRepository

    init(web3Repository: Web3Repository, etherscanRepository: EtherscanRepository) {
        self.web3Repository = web3Repository
        self.etherscanRepository = etherscanRepository
    }

    func fetchBalance(for address: EthereumAddress, completion: @MainActor @escaping (Result<String, Error>) -> Void) {
        Task {
            do {
                let balance = try await web3Repository.fetchBalance(for: address)

                guard let balanceStr = Web3.Utils.formatToEthereumUnits(balance, toUnits: .eth) else {
                    await completion(.failure("Failed to formatToEthereumUnits balance: \(balance)"))
                    return
                }
                await completion(.success(balanceStr))
            } catch {
                await completion(.failure("\(error)"))
            }
        }
    }
    
    func fetchERC20InboundTransfers() async throws {
    }
}
