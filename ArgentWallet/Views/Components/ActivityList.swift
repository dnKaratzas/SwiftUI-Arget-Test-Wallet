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

import OrderedCollections
import SwiftUI
import web3

class ActivityListItemViewModel: Hashable {
    static func == (lhs: ActivityListItemViewModel, rhs: ActivityListItemViewModel) -> Bool {
        return lhs.txHash == rhs.txHash
    }

    let txHash: String
    let amount: String
    let time: String

    let inbound: Bool
    var inboundString: String {
        return inbound ? L10n.recieve : L10n.send
    }

    let status: EthereumTransactionReceiptStatus
    var statusString: String {
        switch status {
        case .success:
            return L10n.confirmed
        case .failure:
            return L10n.failed
        case .notProcessed:
            return L10n.pending
        }
    }

    var statusColor: Color {
        switch status {
        case .success:
            return .green
        case .failure:
            return .red
        case .notProcessed:
            return .yellow
        }
    }

    init(inbound: Bool, txHash: String, status: EthereumTransactionReceiptStatus, amount: String, time: String) {
        self.inbound = inbound
        self.txHash = txHash
        self.status = status
        self.amount = amount
        self.time = time
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(txHash)
    }
}

struct ActivityList: View {
    @Binding var activityList: OrderedSet<ActivityListItemViewModel>
    var body: some View {
        List {
            Section(header: Text(L10n.activity)) {
                ForEach(activityList, id: \.self) { viewModel in
                    VStack {
                        HStack {
                            Text(viewModel.inboundString)
                            Text("-")
                            Text(viewModel.statusString)
                                .foregroundColor(viewModel.statusColor)
                            Spacer()
                            Text(viewModel.time)
                        }
                        HStack {
                            Text(viewModel.txHash)
                                .lineLimit(1)
                                .truncationMode(.middle)
                            Spacer()
                            Text("\(viewModel.amount) ETH")
                        }
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
}
//
struct ActivityListItem_Previews: PreviewProvider {
    static var previews: some View {
        ActivityList(activityList: .constant([ActivityListItemViewModel(inbound: true, txHash: "0x6271E14c57bFD683d348cceBeE9B22698dd40140", status: .success, amount: "0.01", time: "30/06")]))
    }
}
