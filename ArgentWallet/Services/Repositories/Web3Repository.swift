//
//  Web3Repository.swift
//  ArgentWallet
//
//  Created by Dionisis Karatzas on 29/6/22.
//

import BigInt
import Foundation
import Resolver
import web3

struct Web3Repository {
    @Injected private var ethClient: EthereumClient

    func fetchBalance(for address: EthereumAddress) async throws -> BigUInt {
        return try await ethClient.eth_getBalance(address: address, block: .Latest)
    }
}
