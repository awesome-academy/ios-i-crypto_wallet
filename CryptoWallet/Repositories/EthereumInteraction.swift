//
//  EthereumInteraction.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/2/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import Foundation
import Web3swift
import EthereumAddress
import BigInt

enum EthereumInteraction {
    static var web3: web3?
    static let network: EthereumNetwork = .rinkeby
    
    static func createNewWallet(name: String = Constants.appName, password: String) throws -> (Wallet, String) {
        guard let mnemonics = ((try? BIP39.generateMnemonics(bitsOfEntropy: 128)) as String??),
            let unwrapped = mnemonics else {
                throw Web3Error.keystoreError(err: .noEntropyError)
        }
        guard let keystore = ((try? BIP32Keystore(mnemonics: unwrapped,
                                                  password: password,
                                                  mnemonicsPassword: "",
                                                  language: .english,
                                                  prefixPath: "m/44'/60'/0'/0",
                                                  aesMode: "aes-128-cbc")) as BIP32Keystore??),
            let wallet = keystore else {
            throw EthereumInteractionErrors.cantCreateWallet
        }
        guard let keyData = try? JSONEncoder().encode(wallet.keystoreParams),
            let address = wallet.addresses?.first?.address else {
            throw EthereumInteractionErrors.cantCreateWallet
        }
        if self.web3 == nil {
            self.web3 = network.web3Instance
        }
        if let web3 = web3 {
            let keystoreManager = KeystoreManager([wallet])
            web3.addKeystoreManager(keystoreManager)
        }
        let hdWallet = Wallet(walletName: name,
                              walletAddress: address,
                              keyData: keyData,
                              isHierarchicalDeterministic: true)
        return (hdWallet, unwrapped)
    }
    
    static func importWalletByPrivateKey(walletName: String = Constants.appName,
                                         privateKey: String,
                                         password: String) throws -> Wallet {
        guard let data = Data.fromHex(privateKey) else {
            throw EthereumInteractionErrors.cantImportWallet
        }
        guard let newWallet = ((try? EthereumKeystoreV3(privateKey: data,
                                                        password: password,
                                                        aesMode: "aes-128-cbc")) as EthereumKeystoreV3??) else {
            throw EthereumInteractionErrors.cantImportWallet
        }
        guard let wallet = newWallet,
            wallet.addresses?.count == 1,
            let keyData = try? JSONEncoder().encode(wallet.keystoreParams),
            let address = newWallet?.addresses?.first?.address else {
            throw EthereumInteractionErrors.cantImportWallet
        }
        if self.web3 == nil {
            self.web3 = network.web3Instance
        }
        if let web3 = web3 {
            let keystoreManager = KeystoreManager([wallet])
            web3.addKeystoreManager(keystoreManager)
        }
        let importedWallet = Wallet(walletName: walletName,
                                    walletAddress: address,
                                    keyData: keyData,
                                    isHierarchicalDeterministic: false)
        return importedWallet
    }
    
    static func importWalletByMnenomic(walletName: String = Constants.appName,
                                       mnenomicPhrase: String,
                                       password: String) throws -> Wallet {
        guard let keystore = ((try? BIP32Keystore(mnemonics: mnenomicPhrase,
                                                  password: password,
                                                  mnemonicsPassword: "",
                                                  language: .english,
                                                  prefixPath: "m/44'/60'/0'/0",
                                                  aesMode: "aes-128-cbc")) as BIP32Keystore??),
            let wallet = keystore else {
            throw EthereumInteractionErrors.cantImportWallet
        }
        guard let keyData = try? JSONEncoder().encode(wallet.keystoreParams),
            let address = wallet.addresses?.first?.address else {
                throw EthereumInteractionErrors.cantImportWallet
        }
        if self.web3 == nil {
            self.web3 = network.web3Instance
        }
        if let web3 = web3 {
            let keystoreManager = KeystoreManager([wallet])
            web3.addKeystoreManager(keystoreManager)
        }
        let importedWallet = Wallet(walletName: walletName,
                                    walletAddress: address,
                                    keyData: keyData,
                                    isHierarchicalDeterministic: true)
        return importedWallet
    }
    
    static func getERC20TokenBalance(contractAddress: String, walletAddress: String) -> Double? {
        let etherWalletAddress = EthereumAddress(walletAddress)
        let exploredAddress = EthereumAddress(walletAddress)
        let erc20ContractAddress = EthereumAddress(contractAddress)
        guard let web3 = web3 else {
            return nil
        }
        guard let contract = web3.contract(Web3.Utils.erc20ABI, at: erc20ContractAddress, abiVersion: 2) else {
            return nil
        }
        var options = TransactionOptions.defaultOptions
        options.from = etherWalletAddress
        options.gasPrice = .automatic
        options.gasLimit = .automatic
        let method = "balanceOf"
        guard let transaction = contract.read(
            method,
            parameters: [exploredAddress] as [AnyObject],
            extraData: Data(),
            transactionOptions: options) else {
                return nil
        }
        do {
            let tokenBalance = try transaction.call()
            guard let balanceBigUInt = tokenBalance["0"] as? BigUInt else {
                return nil
            }
            return Double(balanceBigUInt)
        } catch {
            return nil
        }
    }
    
    static func getEtherBalance(address: String) -> String? {
        guard let walletAddress = EthereumAddress(address), let web3 = web3 else {
            return nil
        }
        do {
            let balanceResult = try web3.eth.getBalance(address: walletAddress)
            return Web3.Utils.formatToEthereumUnits(balanceResult, toUnits: .eth, decimals: 18)
        } catch {
            return nil
        }
    }

    static func getEstimatedFee(_ assetType: AssetType) -> (estimatedFee: Double, gasPrice: Double)? {
        guard let web3 = web3 else {
            return nil
        }
        do {
            let gasPrice = try web3.eth.getGasPrice()
            let estimatedFee = gasPrice * (assetType == .coin ?
                Constants.gasLimitEtherDefault :
                Constants.gasLimitTokenDefault)
            guard let stringFee = Web3.Utils.formatToEthereumUnits(estimatedFee,
                                                                   toUnits: .eth,
                                                                   decimals: 18),
                let fee = Double(stringFee) else {
                return nil
            }
            return (fee, Double(gasPrice))
        } catch {
            return nil
        }
    }
    
    static func sendEther(toAddress: String,
                          value: Double,
                          gasPrice: Double,
                          gasLimit: Double,
                          data: Data = Data(),
                          password: String) throws -> TransactionSendingResult? {
        guard let wallet = Wallet.sharedWallet, let web3 = web3 else {
            return nil
        }
        let walletAddress = EthereumAddress(wallet.walletAddress)
        let toAddress = EthereumAddress(toAddress)
        let amount = Web3.Utils.parseToBigUInt(String(value), units: .eth)
        var options = TransactionOptions.defaultOptions
        options.value = amount
        options.from = walletAddress
        options.gasPrice = .manual(BigUInt(gasPrice))
        options.gasLimit = .manual(BigUInt(gasLimit))
        let method = "fallback"
        guard let contract = web3.contract(Web3.Utils.coldWalletABI,
                                           at: toAddress,
                                           abiVersion: 2),
              let transaction = contract.write(method,
                                               parameters: [AnyObject](),
                                               extraData: data,
                                               transactionOptions: options)
        else {
            return nil
        }
        return (try transaction.send(password: password))
    }
    
    static func sendERC20Token(smartContract: String,
                               toAddress: String,
                               value: Double,
                               gasPrice: Double,
                               gasLimit: Double,
                               data: Data = Data(),
                               password: String) throws -> TransactionSendingResult? {
        guard let wallet = Wallet.sharedWallet, let web3 = web3 else {
            return nil
        }
        let walletAddress = EthereumAddress(wallet.walletAddress)
        let toAddress = EthereumAddress(toAddress)
        let erc20ContractAddress = EthereumAddress(smartContract)
        let amount = Web3.Utils.parseToBigUInt(String(value), units: .eth) // has problem
        var options = TransactionOptions.defaultOptions
        let parameters = [toAddress, amount] as [AnyObject]
        options.value = amount
        options.from = walletAddress
        options.gasPrice = .manual(BigUInt(gasPrice))
        options.gasLimit = .manual(BigUInt(gasLimit))
        let method = "transfer"
        guard let contract = web3.contract(Web3.Utils.erc20ABI,
                                           at: erc20ContractAddress,
                                           abiVersion: 2),
              let transaction = contract.write(method,
                                               parameters: parameters,
                                               extraData: data,
                                               transactionOptions: options)
        else {
            return  nil
        }
        return (try transaction.send(password: password))
    }
    
    static func subscribePendingTransaction(forDelegate delegate: Web3SocketDelegate) {
        guard let web3 = web3 else {
            return
        }
        do {
            try web3.eth.subscribeOnPendingTransactions(forDelegate: delegate)
        } catch {
            print(error.localizedDescription)
        }
    }
}
