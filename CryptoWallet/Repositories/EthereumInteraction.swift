//
//  EthereumInteraction.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/2/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import Foundation
import Web3swift

enum EthereumInteraction {
    static func createNewWallet(name: String = Constants.appName, password: String) throws -> (Wallet, String) {
        guard let mnemonics = try? BIP39.generateMnemonics(bitsOfEntropy: 128),
            let unwrapped = mnemonics else {
                throw Web3Error.keystoreError(err: .noEntropyError)
        }
        guard let keystore = try? BIP32Keystore(mnemonics: unwrapped,
                                                password: password,
                                                mnemonicsPassword: "",
                                                language: .english,
                                                prefixPath: "m/44'/60'/0'/0",
                                                aesMode: "aes-128-cbc"), let wallet = keystore else {
            throw EthereumInteractionErrors.cantCreateWallet
        }
        guard let keyData = try? JSONEncoder().encode(wallet.keystoreParams),
            let address = wallet.addresses?.first?.address else {
            throw EthereumInteractionErrors.cantCreateWallet
        }
        let hdWallet = Wallet(walletName: name,
                              walletAddress: address,
                              keyData: keyData,
                              isHierarchicalDeterministic: true)
        return (hdWallet, unwrapped)
    }
}
