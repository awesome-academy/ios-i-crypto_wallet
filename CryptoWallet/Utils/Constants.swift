//
//  Constans.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 3/29/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import Foundation
import BigInt

enum Constants {
    static let appName = "CryptoWallet"
    static let passwordKey = "passwordKey"
    static let recoveryDataKey = "recoveryDataKey"
    static let walletNameKey = "walletNameKey"
    static let gasLimitEtherDefault: BigUInt = 21_000
    static let gasLimitTokenDefault: BigUInt = 100_000
    static let indicatorTag = 100
}
