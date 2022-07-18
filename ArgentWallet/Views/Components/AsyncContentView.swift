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
                .accessibilityIdentifier(AppConstants.A11y.loadingDialog)
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
