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

import Resolver
import SimpleToast
import SwiftUI

struct MainView: View {
    @ObservedObject private var viewModel: MainViewModel = Resolver.resolve()
    @State var isLinkActive = false

    var body: some View {
        AsyncContentView(state: $viewModel.state) {
            NavigationView {
                VStack {
                    WalletImage.EthLogo
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 80)
                        .padding()

                    Text(L10n.walletBalance)
                        .accessibilityIdentifier(AppConstants.A11y.balanceLabel)
                    Text("\(viewModel.balance) ETH")
                        .font(.title)

                    VStack {
                        Button {
                            Task {
                                await viewModel.sendEthereum()
                            }
                        } label: {
                            Label(L10n.sendEth, systemImage: "paperplane.circle.fill")
                                .frame(maxWidth: .infinity)
                        }
                        .frame(maxWidth: .infinity)
                        .buttonStyle(.borderedProminent)

                        NavigationLink(destination: ERC20TransfersView(), isActive: $isLinkActive) {
                            Button {
                                self.isLinkActive = true
                            } label: {
                                Label(L10n.viewErcTransactions, systemImage: "clock.fill")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(30)

                    ActivityList(activityList: $viewModel.activityList)
                }
                .navigationBarHidden(true)
            }
        }
        .task(priority: .userInitiated) {
            await viewModel.fetchAccountBalance()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
