//
//  String++.swift
//  ArgentWallet
//
//  Created by Dionisis Karatzas on 29/6/22.
//

import Foundation

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}
