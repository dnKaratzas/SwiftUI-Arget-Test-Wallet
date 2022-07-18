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

// MARK: - ERC20Transfers
struct ERC20Transfers: Codable {
    let status: String
    let message: String
    let transfers: [ERC20Transfer]

    enum CodingKeys: String, CodingKey {
        case status
        case message
        case transfers = "result"
    }

    init(status: String, message: String, transfers: [ERC20Transfer]) {
        self.status = status
        self.message = message
        self.transfers = transfers
    }
}

// MARK: - Result
struct ERC20Transfer: Codable, Hashable {
    let blockNumber: String
    let timeStamp: String
    let hash: String
    let nonce: String
    let blockHash: String
    let from: String
    let contractAddress: String
    let to: String
    let value: String
    let tokenName: String
    let tokenSymbol: String
    let tokenDecimal: String

    var amount: String {
        guard let bigValue = Web3Utils.parseToBigUInt(value, decimals: 0), let tokenDecimal = Int(tokenDecimal) else { return "" }
        return Web3Utils.formatToPrecision(bigValue, numberDecimals: tokenDecimal, formattingDecimals: 10) ?? ""
    }

    init(blockNumber: String, timeStamp: String, hash: String, nonce: String, blockHash: String, from: String, contractAddress: String, to: String, value: String, tokenName: String, tokenSymbol: String, tokenDecimal: String) {
        self.blockNumber = blockNumber
        self.timeStamp = timeStamp
        self.hash = hash
        self.nonce = nonce
        self.blockHash = blockHash
        self.from = from
        self.contractAddress = contractAddress
        self.to = to
        self.value = value
        self.tokenName = tokenName
        self.tokenSymbol = tokenSymbol
        self.tokenDecimal = tokenDecimal
    }
}
