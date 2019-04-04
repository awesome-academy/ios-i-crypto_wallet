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
    
    static func importWalletByPrivateKey(walletName: String,
                                         privateKey: String,
                                         password: String) throws -> Wallet {
        guard let data = Data.fromHex(privateKey) else {
            throw EthereumInteractionErrors.cantImportWallet
        }
        
        guard let newWallet = try? EthereumKeystoreV3(privateKey: data,
                                                      password: password,
                                                      aesMode: "aes-128-cbc") else {
            throw EthereumInteractionErrors.cantImportWallet
        }
        
        guard let wallet = newWallet,
            wallet.addresses?.count == 1,
            let keyData = try? JSONEncoder().encode(wallet.keystoreParams),
            let address = newWallet?.addresses?.first?.address else {
            throw EthereumInteractionErrors.cantImportWallet
        }
        
        let importedWallet = Wallet(walletName: walletName,
                                    walletAddress: address,
                                    keyData: keyData,
                                    isHierarchicalDeterministic: false)
        return importedWallet
    }
    
    static func importWalletByMnenomic(walletName: String,
                                       mnenomicPhrase: String,
                                       password: String) throws -> Wallet {
        guard let keystore = try? BIP32Keystore(mnemonics: mnenomicPhrase,
                                                password: password,
                                                mnemonicsPassword: "",
                                                language: .english,
                                                prefixPath: "m/44'/60'/0'/0",
                                                aesMode: "aes-128-cbc"), let wallet = keystore else {
                                                    throw EthereumInteractionErrors.cantImportWallet
        }
        guard let keyData = try? JSONEncoder().encode(wallet.keystoreParams),
            let address = wallet.addresses?.first?.address else {
                throw EthereumInteractionErrors.cantImportWallet
        }
        let importedWallet = Wallet(walletName: walletName,
                                    walletAddress: address,
                                    keyData: keyData,
                                    isHierarchicalDeterministic: true)
        return importedWallet
    }
}
