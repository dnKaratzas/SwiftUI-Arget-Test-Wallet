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

struct EtherscanRepository {
    @Injected private var sessionConfig: URLSessionConfiguration

    func fetchERC20Transfers() async throws -> ERC20Transfers {
        var url = AppConstants.etherscanApiUrl
        url.appendQueryItem(name: "address", value: AppConstants.walletAddress.value)
        url.appendQueryItem(name: "apikey", value: AppConstants.etherscanApiKey)
        url.appendQueryItem(name: "module", value: "account")
        url.appendQueryItem(name: "action", value: "tokentx")
        url.appendQueryItem(name: "startblock", value: "0")

        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession(configuration: sessionConfig).data(for: urlRequest)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw "Error while fetching data"
        }

        let decodedResult = try JSONDecoder().decode(ERC20Transfers.self, from: data)
        return decodedResult
    }
}
