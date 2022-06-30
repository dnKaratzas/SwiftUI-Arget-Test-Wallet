//
//  Web3Repository.swift
//  ArgentWallet
//
//  Created by Dionisis Karatzas on 29/6/22.
//

import BigInt
import Foundation
import Resolver
import web3

struct Web3Repository {
    @Injected private var ethClient: EthereumClient

    func fetchBalance(for address: EthereumAddress) async throws -> BigUInt {
        return try await ethClient.eth_getBalance(address: address, block: .Latest)
    }

    func sendEth(walletAddress: EthereumAddress, tokenAddress: EthereumAddress, toAddress: EthereumAddress, account: EthereumAccountProtocol, amount: String) async throws -> String {
        guard let gasPrice = Web3.Utils.parseToBigUInt(String("12"), units: .gWei) else {
            throw "Failed to parse gasLimit"
        }

        guard let gasLimit = Web3.Utils.parseToBigUInt(String("250000"), units: .wei) else {
            throw "Failed to parse gasLimit"
        }

        guard let ethAmount = Web3.Utils.parseToBigUInt(amount, units: .eth) else {
            throw "Failed to parse Eth Amount"
        }

        let function = TransferToken(wallet: walletAddress, token: tokenAddress, to: toAddress, amount: ethAmount, data: Data(), gasPrice: gasPrice, gasLimit: gasLimit)

        let transaction = try function.transaction()
        let txHash = try await ethClient.eth_sendRawTransaction(transaction, withAccount: account)

        return txHash
    }

    func fetchTransactionReceipt(for txHash: String) async throws -> EthereumTransactionReceipt {
        logger.trace("Fetching transaction receipt for txhash: \(txHash)")
        var receipt: EthereumTransactionReceipt?
        // TODO: add retry limit
        while receipt == nil {
            do {
                receipt = try await ethClient.eth_getTransactionReceipt(txHash: txHash)
            } catch {
                logger.trace("Failed to get getTransactionReceipt - Error: \(error)")
            }
            do {
                try await Task.sleep(seconds: 0.5)
            } catch {
                logger.trace("Failed to Task.sleep - Error: \(error)")
            }
        }

        return receipt!
    }

    private struct TransferToken: ABIFunction {
        static let name = "transferToken"
        let contract = AppConstants.transferManagerContract
        let from: EthereumAddress? = nil

        let wallet: EthereumAddress
        let token: EthereumAddress
        let to: EthereumAddress
        let amount: BigUInt
        let data: Data

        let gasPrice: BigUInt?
        let gasLimit: BigUInt?

        func encode(to encoder: ABIFunctionEncoder) throws {
            try encoder.encode(wallet)
            try encoder.encode(token)
            try encoder.encode(to)
            try encoder.encode(amount)
            try encoder.encode(data)
        }
    }
}
