// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Activity
  internal static let activity = L10n.tr("Localizable", "activity")
  /// Confirmed
  internal static let confirmed = L10n.tr("Localizable", "confirmed")
  /// Failed
  internal static let failed = L10n.tr("Localizable", "failed")
  /// An unexpected error occured. Please try again.
  internal static let genericSystemError = L10n.tr("Localizable", "generic_system_error")
  /// Pending
  internal static let pending = L10n.tr("Localizable", "pending")
  /// Loading...
  internal static let progressViewLoading = L10n.tr("Localizable", "progress_view_loading")
  /// Recieve
  internal static let recieve = L10n.tr("Localizable", "recieve")
  /// Send
  internal static let send = L10n.tr("Localizable", "send")
  /// Send 0.01 ETH
  internal static let sendEth = L10n.tr("Localizable", "send_eth")
  /// View ERC20 Trasfers
  internal static let viewErcTransactions = L10n.tr("Localizable", "view_erc_transactions")
  /// Wallet Balance
  internal static let walletBalance = L10n.tr("Localizable", "wallet_balance")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
