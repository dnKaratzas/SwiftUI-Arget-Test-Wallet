//
//  AsyncContentView.swift
//  ArgentWallet
//
//  Created by Dionisis Karatzas on 29/6/22.
//

import SwiftUI
import SimpleToast

struct AsyncContentView<Content: View>: View {
    @Binding var state: ViewState
    @ViewBuilder var content: Content

    private let toastOptions = SimpleToastOptions(
        alignment: .bottom,
        hideAfter: 5
    )

    var body: some View {
        ZStack {
            switch state {
            case .idle:
                content
            case .loading:
                content
                ProgressView("Loading")
                    .foregroundColor(.white)
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
            case .failed(let error):
                ZStack {
                    content
                }
                .simpleToast(isPresented: .constant(true), options: toastOptions) {
                    HStack {
                        Image(systemName: "exclamationmark.triangle")
                        Text(error)
                    }
                    .padding()
                    .background(WalletColor.Error)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .offset(x: 0, y: -20)
                }
            }
        }
    }
}
