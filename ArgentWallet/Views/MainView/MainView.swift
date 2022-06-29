//
//  MainView.swift
//  ArgentWallet
//
//  Created by Dionisis Karatzas on 29/6/22.
//

import SwiftUI
import Resolver
import SimpleToast

struct MainView: View {
    @ObservedObject private var viewModel: MainViewModel = Resolver.resolve()

    var body: some View {
        AsyncContentView(state: $viewModel.state) {
            NavigationView {
                ZStack {
                    BackgroundView()
                    VStack {
                        Text(viewModel.balance)
                        Spacer()
                    }
                }
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
