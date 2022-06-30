//
//  MainView.swift
//  ArgentWallet
//
//  Created by Dionisis Karatzas on 29/6/22.
//

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
                    Text("\(viewModel.balance) ETH")
                        .font(.title)

                    VStack {
                        Button {
                            viewModel.sendEthereum()
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

                    Spacer()
                }
                .navigationBarHidden(true)
            }
        }
        .onAppear {
            viewModel.fetchAccountBalance()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
