//
//  ArgentWalletApp.swift
//  ArgentWallet
//
//  Created by Dionisis Karatzas on 29/6/22.
//

import Logging
import SwiftUI

let logger = Logger(label: "eu.dkaratzas.argent-wallet")

@main
struct ArgentWalletApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
