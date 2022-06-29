//
//  Double++.swift
//  ArgentWallet
//
//  Created by Dionisis Karatzas on 29/6/22.
//

import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func rounded(_ places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded(.down) / divisor
    }
}
