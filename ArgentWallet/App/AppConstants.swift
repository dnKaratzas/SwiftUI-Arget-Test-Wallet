//
//  AppConstants.swift
//  ArgentWallet
//
//  Created by Dionisis Karatzas on 29/6/22.
//

import Foundation

// swiftlint:disable force_unwrapping
enum AppConstants {
    static let infuraURL = URL(string: "https://ropsten.infura.io/v3/735489d9f846491faae7a31e1862d24b")!
    static let etherscanApiKey = "Your Etherscan API key"
    static let walletPrivateKey = "0xec983791a21bea916170ee0aead71ab95c13280656e93ea4124c447bbd9a24a2"
    static let transferManagerContract = "0xcdAd167a8A9EAd2DECEdA7c8cC908108b0Cc06D1"
    static let keystorePassword = "asgdvcrTUE@Dcf2vb1u"

    // That address would be the receipient for the send eth action of the app.
    static let toAddress = "0x6271E14c57bFD683d348cceBeE9B22698dd40140"

    enum A11y {
    }
}
// swiftlint:enable force_unwrapping
