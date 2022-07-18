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

@testable import ArgentWallet
import Foundation
import web3

class MockWalletService: WalletServiceProtocol {
    func fetchBalance(for address: EthereumAddress, completion: @escaping (Result<String, Error>) -> Void) {
        completion(.success("12.5"))
    }

    func sendEth(walletAddress: EthereumAddress, tokenAddress: EthereumAddress, toAddress: EthereumAddress, account: EthereumAccountProtocol, amount: String, completion: @escaping (Result<String, Error>) -> Void) {
        completion(.success("txHash"))
    }

    func fetchTransactionReceipt(for txHash: String, completion: @escaping (Result<EthereumTransactionReceipt, Error>) -> Void) {
    }

    func fetchERC20Transfers(completion: @escaping (Result<[ERC20Transfer], Error>) -> Void) {
        let jsonData = Bundle.stubbedDataFromJson(filename: "ERC20Transfers")
        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode(ERC20Transfers.self, from: jsonData)
            completion(.success(result.transfers))
        } catch {
            completion(.failure("ERC20Transfers.json decode failed \(error)"))
        }
    }
}
