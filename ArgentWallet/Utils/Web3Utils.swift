//
//  web3swift
//
//  Created by Alex Vlasov.
//  Copyright © 2018 Alex Vlasov. All rights reserved.
//

import Foundation
import BigInt

// namespace
public enum Web3 {
    public enum Utils {
    }
}

public typealias Web3Utils = Web3.Utils

extension Web3.Utils {
    /// Various units used in Ethereum ecosystem
    enum Units {
        case eth
        case wei
        case kWei
        case mWei
        case gWei
        case microether
        case finney

        var decimals: Int {
            switch self {
            case .eth:
                return 18
            case .wei:
                return 0
            case .kWei:
                return 3
            case .mWei:
                return 6
            case .gWei:
                return 9
            case .microether:
                return 12
            case .finney:
                return 15
            }
        }
    }
}

extension Web3.Utils {
    /// Formats a BigUInt object to String. The supplied number is first divided into integer and decimal part based on "toUnits",
    /// then limit the decimal part to "decimals" symbols and uses a "decimalSeparator" as a separator.
    ///
    /// Returns nil of formatting is not possible to satisfy.
    static func formatToEthereumUnits(_ bigNumber: BigUInt, toUnits: Web3.Utils.Units = .eth, decimals: Int = 4, decimalSeparator: String = ".", fallbackToScientific: Bool = false) -> String? {
        return formatToPrecision(bigNumber, numberDecimals: toUnits.decimals, formattingDecimals: decimals, decimalSeparator: decimalSeparator, fallbackToScientific: fallbackToScientific)
    }

    /// Formats a BigUInt object to String. The supplied number is first divided into integer and decimal part based on "numberDecimals",
    /// then limits the decimal part to "formattingDecimals" symbols and uses a "decimalSeparator" as a separator.
    /// Fallbacks to scientific format if higher precision is required.
    ///
    /// Returns nil of formatting is not possible to satisfy.
    static func formatToPrecision(_ bigNumber: BigUInt, numberDecimals: Int = 18, formattingDecimals: Int = 4, decimalSeparator: String = ".", fallbackToScientific: Bool = false) -> String? {
        if bigNumber == 0 {
            return "0"
        }
        let unitDecimals = numberDecimals
        var toDecimals = formattingDecimals
        if unitDecimals < toDecimals {
            toDecimals = unitDecimals
        }
        let divisor = BigUInt(10).power(unitDecimals)
        let (quotient, remainder) = bigNumber.quotientAndRemainder(dividingBy: divisor)
        var fullRemainder = String(remainder)
        let fullPaddedRemainder = fullRemainder.leftPadding(toLength: unitDecimals, withPad: "0")
        let remainderPadded = fullPaddedRemainder[0..<toDecimals]
        if remainderPadded == String(repeating: "0", count: toDecimals) {
            if quotient != 0 {
                return String(quotient)
            } else if fallbackToScientific {
                var firstDigit = 0
                for char in fullPaddedRemainder {
                    if char == "0" {
                        firstDigit += 1
                    } else {
                        let firstDecimalUnit = String(fullPaddedRemainder[firstDigit ..< firstDigit + 1])
                        var remainingDigits = ""
                        let numOfRemainingDecimals = fullPaddedRemainder.count - firstDigit - 1
                        if numOfRemainingDecimals <= 0 {
                            remainingDigits = ""
                        } else if numOfRemainingDecimals > formattingDecimals {
                            let end = firstDigit + 1 + formattingDecimals > fullPaddedRemainder.count ? fullPaddedRemainder.count : firstDigit + 1 + formattingDecimals
                            remainingDigits = String(fullPaddedRemainder[firstDigit + 1 ..< end])
                        } else {
                            remainingDigits = String(fullPaddedRemainder[firstDigit + 1 ..< fullPaddedRemainder.count])
                        }
                        if !remainingDigits.isEmpty {
                            fullRemainder = firstDecimalUnit + decimalSeparator + remainingDigits
                        } else {
                            fullRemainder = firstDecimalUnit
                        }
                        firstDigit += 1
                        break
                    }
                }
                return fullRemainder + "e-" + String(firstDigit)
            }
        }
        if toDecimals == 0 {
            return String(quotient)
        }
        return String(quotient) + decimalSeparator + remainderPadded
    }
}

private extension String {
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(self.startIndex, offsetBy: bounds.lowerBound)
        let end = index(self.startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }

    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(self.startIndex, offsetBy: bounds.lowerBound)
        let end = index(self.startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }

    subscript (bounds: CountablePartialRangeFrom<Int>) -> String {
        let start = index(self.startIndex, offsetBy: bounds.lowerBound)
        let end = self.endIndex
        return String(self[start..<end])
    }

    func leftPadding(toLength: Int, withPad character: Character) -> String {
        let stringLength = self.count
        if stringLength < toLength {
            return String(repeatElement(character, count: toLength - stringLength)) + self
        } else {
            return String(self.suffix(toLength))
        }
    }
}
