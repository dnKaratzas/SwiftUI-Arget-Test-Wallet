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
import SwiftUI

struct ERC20TransfersView: View {
    @StateObject private var viewModel: ERC20TransfersViewModel = Resolver.resolve()
    var body: some View {
        AsyncContentView(state: $viewModel.state) {
            List(viewModel.transfers, id: \.self) { transfer in
                VStack(alignment: .leading) {
                    Text("From: \(transfer.from)")
                        .lineLimit(1)
                        .truncationMode(.middle)
                    Text("Token: \(transfer.contractAddress)")
                        .lineLimit(1)
                        .truncationMode(.middle)
                    Text("Amount: \(transfer.amount) (\(transfer.tokenSymbol))")
                }
            }
        }
        .navigationTitle("ERC20 Transfers")
        .navigationBarTitleDisplayMode(.inline)
        .task(priority: .userInitiated) {
            await viewModel.fetchTransfers()
        }
    }
}

struct ERC20TransfersView_Previews: PreviewProvider {
    static var previews: some View {
        ERC20TransfersView()
    }
}
