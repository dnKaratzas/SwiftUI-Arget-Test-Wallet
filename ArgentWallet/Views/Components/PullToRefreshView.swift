//
//  PullToRefreshView.swift
//  ArgentWallet
//
//  Created by Dionisis Karatzas on 29/6/22.
//

import SwiftUI

struct PullToRefreshView: View {
    var coordinateSpaceName: String
    var onRefresh: () -> Void

    @State var needRefresh = false

    var body: some View {
        GeometryReader { geo in
            if geo.frame(in: .named(coordinateSpaceName)).midY > 50 {
                Spacer()
                    .onAppear {
                        needRefresh = true
                    }
            } else if geo.frame(in: .named(coordinateSpaceName)).maxY < 10 {
                Spacer()
                    .onAppear {
                        if needRefresh {
                            needRefresh = false
                            onRefresh()
                        }
                    }
            }
            HStack {
                Spacer()
                if needRefresh {
                    ProgressView()
                } else {
                    Text("⬇️")
                }
                Spacer()
            }
        }.padding(.top, -50)
    }
}

struct PullToRefreshView_Previews: PreviewProvider {
    static var previews: some View {
        PullToRefreshView(coordinateSpaceName: "") {}
    }
}
