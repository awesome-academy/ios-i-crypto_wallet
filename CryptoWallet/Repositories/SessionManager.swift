//
//  LoginManager.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/4/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import Foundation
import Valet

enum SessionManager {
    
    static func checkLogin() throws -> Bool {
        guard let id = Identifier(nonEmpty: Constants.appName) else {
            throw SessionErrors.cantCreateIdentifier
        }
        let myValet = Valet.valet(with: id, accessibility: .whenUnlockedThisDeviceOnly)
        guard let recoveryData = myValet.string(forKey: Constants.recoveryDataKey),
            let password = myValet.string(forKey: Constants.passwordKey),
            let walletName = myValet.string(forKey: Constants.walletNameKey) else {
                return false
        }
        let arrayData = recoveryData.split(separator: ":")
        var wallet = Wallet()
        if arrayData.count >= 2 {
            let walletType = arrayData[0]
            wallet = walletType == "0" ? try EthereumInteraction.importWalletByMnenomic(
                walletName: walletName,
                mnenomicPhrase: String(arrayData[1]),
                password: password) :
            try EthereumInteraction.importWalletByPrivateKey(walletName: walletName,
                                                             privateKey: String(arrayData[1]),
                                                             password: password)
        }
        Wallet.sharedWallet = wallet
        return true
    }
    
    static func logout() throws {
        guard let id = Identifier(nonEmpty: Constants.appName) else {
            throw SessionErrors.cantCreateIdentifier
        }
        let myValet = Valet.valet(with: id, accessibility: .whenUnlockedThisDeviceOnly)
        myValet.removeAllObjects()
    }
}
