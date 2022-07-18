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

    func fetchTransactionReceipt(for txHash: String) async throws -> EthereumTransactionReceipt? {
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

        return receipt
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
