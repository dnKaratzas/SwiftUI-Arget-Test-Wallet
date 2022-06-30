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
import Resolver
import web3

// swiftlint:disable force_try

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        defaultScope = .graph

        register { URLSessionConfiguration.default }
        register { EthereumClient(url: AppConstants.infuraURL, sessionConfig: resolve()) }.implements(EthereumClientProtocol.self)
        register { try! EthereumAccount.importAccount(keyStorage: EthereumKeyLocalStorage(), privateKey: AppConstants.walletPrivateKey, keystorePassword: AppConstants.keystorePassword) }.implements(EthereumAccountProtocol.self)
        register { WalletService(web3Repository: Web3Repository(), etherscanRepository: EtherscanRepository()) }.implements(WalletServiceProtocol.self)
        register { MainViewModel() }
    }
}
// swiftlint:enable force_try
