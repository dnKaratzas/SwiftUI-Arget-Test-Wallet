//
//  Bundle++.swift
//  ArgentWalletTests
//
//  Created by Dionisis Karatzas on 30/6/22.
//

import Foundation
import XCTest

extension Bundle {
    static func stubbedDataFromJson(filename: String) -> Data {
        return stubbedData(filename: filename, withExtension: "json")
    }

    static func stubbedData(filename: String, withExtension fileExtension: String) -> Data {
        guard  let stubURL = Bundle(for: MainViewModelTests.self).url(forResource: filename, withExtension: fileExtension) else {
            XCTAssert(false, "\(filename).\(fileExtension) file not found")
            fatalError("file not found")
        }
        guard let stubData = try? Data(contentsOf: stubURL) else {
            XCTAssert(false, "\(filename).\(fileExtension) file cannot be read")
            fatalError("file cannot be read")
        }
        return stubData
    }
}
