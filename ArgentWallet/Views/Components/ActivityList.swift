//
//  ActivityList.swift
//  ArgentWallet
//
//  Created by Dionisis Karatzas on 30/6/22.
//

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
        .onAppear {
            UITableView.appearance().backgroundColor = .clear
        }
    }
}
//
struct ActivityListItem_Previews: PreviewProvider {
    static var previews: some View {
        ActivityList(activityList: .constant([ActivityListItemViewModel(inbound: true, txHash: "0x6271E14c57bFD683d348cceBeE9B22698dd40140", status: .success, amount: "0.01", time: "30/06")]))
    }
}
