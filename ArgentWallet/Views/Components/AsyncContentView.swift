//
//  AsyncContentView.swift
//  ArgentWallet
//
//  Created by Dionisis Karatzas on 29/6/22.
//

import SimpleToast
import SwiftUI

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
            case .loading(let text):
                LoadingView(isShowing: .constant(true), text: text) {
                    content
                }
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

private struct LoadingView<Content>: View where Content: View {
    @Binding var isShowing: Bool
    var text: String?
    var content: () -> Content

    var body: some View {
        GeometryReader { _ in
            ZStack(alignment: .center) {
                content()
                    .disabled(isShowing)
                    .blur(radius: isShowing ? 2 : 0)
                if isShowing {
                    Rectangle()
                        .fill(Color.black).opacity(isShowing ? 0.6 : 0)
                        .edgesIgnoringSafeArea(.all)

                    VStack(spacing: 48) {
                        ProgressView().scaleEffect(1.5, anchor: .center)
                        Text(text ?? L10n.progressViewLoading).font(.title2).fontWeight(.semibold)
                    }
                    .frame(width: 250, height: 200)
                    .background(Color.white).opacity(0.8)
                    .foregroundColor(Color.primary)
                    .cornerRadius(16)
                }
            }
        }
    }
}
