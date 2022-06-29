//
//  BackgroundView.swift
//  ArgentWallet
//
//  Created by Dionisis Karatzas on 29/6/22.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        ZStack {
            LinearGradient(gradient:
                            Gradient(colors: [
                                WalletColor.AppBackground,
                                WalletColor.AppBackground,
                                WalletColor.AccentColor,
                            ]), startPoint: .top, endPoint: .bottomTrailing)

            VisualEffectView(effect: UIBlurEffect(style: .systemMaterialDark))
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
    }
}
