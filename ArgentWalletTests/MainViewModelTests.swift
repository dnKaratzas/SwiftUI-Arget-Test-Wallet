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
import Combine
import Resolver
import XCTest

// swiftlint:disable implicitly_unwrapped_optional
class MainViewModelTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()
    private var viewModel: MainViewModel!

    override func setUp() {
        super.setUp()
        Resolver.registerMockServices()

        viewModel = MainViewModel(ethAccount: Resolver.resolve(), walletService: Resolver.resolve())
    }

    func testFetchAccountBalance() {
        let expectation = XCTestExpectation(description: "fetchAccountBalanceResult")
        XCTAssertEqual(viewModel.state, .idle)

        viewModel.$balance
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.fetchAccountBalance()
        XCTAssertEqual(viewModel.state, .loading(L10n.loadingBalance))

        wait(for: [expectation], timeout: 5)

        XCTAssertEqual(viewModel.balance, "12.5")
    }

    func testSendEth() {
        let expectation = XCTestExpectation(description: "sendEthereumResult")
        XCTAssertEqual(viewModel.state, .idle)

        viewModel.$activityList
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.sendEthereum()
        XCTAssertEqual(viewModel.state, .loading(L10n.sendingEth))

        wait(for: [expectation], timeout: 5)

        XCTAssertEqual(viewModel.activityList.count, 1)
    }
}
// swiftlint:enable implicitly_unwrapped_optional
