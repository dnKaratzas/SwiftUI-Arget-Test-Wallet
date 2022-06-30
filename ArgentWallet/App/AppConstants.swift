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
import web3

// swiftlint:disable force_unwrapping
enum AppConstants {
    static let infuraURL = URL(string: "https://ropsten.infura.io/v3/735489d9f846491faae7a31e1862d24b")!
    static let etherscanApiKey = "Your Etherscan API key"
    static let ethAddress = EthereumAddress("0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE")
    static let walletAddress = EthereumAddress("0x70ABd7F0c9Bdc109b579180B272525880Fb7E0cB")
    static let walletPrivateKey = "0xec983791a21bea916170ee0aead71ab95c13280656e93ea4124c447bbd9a24a2"
    static let transferManagerContract = EthereumAddress("0xcdAd167a8A9EAd2DECEdA7c8cC908108b0Cc06D1")
    static let keystorePassword = "asgdvcrTUE@Dcf2vb1u"

    // That address would be the receipient for the send eth action of the app.
    static let toAddress = EthereumAddress("0x6271E14c57bFD683d348cceBeE9B22698dd40140")

    enum A11y {
    }
}
// swiftlint:enable force_unwrapping
