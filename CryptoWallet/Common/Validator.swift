//
//  Validator.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/2/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import Foundation
import Validator

protocol ValidatorConvertible {
    func validated(_ value: String) -> ValidationResult
}

enum ValidatorType {
    case password
    case privateKey
    case mnenomicPhrase
    case walletAddress
    case number
    case transactionData
}

enum ValidatorFactory {
    static func validatorFor(type: ValidatorType) -> ValidatorConvertible {
        switch type {
        case .password:
            return PasswordValidator()
        case .privateKey:
            return PrivateKeyValidator()
        case .mnenomicPhrase:
            return MnenomicPhraseValidator()
        case .walletAddress:
            return WalletAddressValidator()
        case .number:
            return NumberValidator()
        case .transactionData:
            return TransactionDataValidator()
        }
    }
}

final class PasswordValidator: ValidatorConvertible {
    func validatedEquality(_ firstValue: String, _ secondValue: String) -> ValidationResult {
        let comfirmPasswordRule = ValidationRuleEquality(dynamicTarget: { return secondValue },
                                                         error: ValidationErrors.notSamePassword)
        return firstValue.validate(rule: comfirmPasswordRule)
    }
    
    func validated(_ value: String) -> ValidationResult {
        let passwordRule = ValidationRulePattern(pattern: "^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9])(?=.*[a-z]).{8,16}$",
                                                 error: ValidationErrors.invalidPassword)
        return value.validate(rule: passwordRule)
    }
}

final class PrivateKeyValidator: ValidatorConvertible {
    func validated(_ value: String) -> ValidationResult {
        let privateKeyRule = ValidationRulePattern(pattern: "^([a-fA-F0-9]){64,64}$",
                                                   error: ValidationErrors.invalidPrivateKey)
        return value.validate(rule: privateKeyRule)
    }
}

final class MnenomicPhraseValidator: ValidatorConvertible {
    func validated(_ value: String) -> ValidationResult {
        let words = value.split(separator: " ")
        if words.count == 12 {
            let mnenomicPhraseRule = ValidationRulePattern(pattern: "^([a-z\\sA-Z]){0,100}$",
                                                           error: ValidationErrors.invalidMnenomicPhrase)
            return value.validate(rule: mnenomicPhraseRule)
        }
        return ValidationResult.invalid([ValidationErrors.invalidMnenomicPhrase])
    }
}

final class WalletAddressValidator: ValidatorConvertible {
    func validated(_ value: String) -> ValidationResult {
        let walletAddressRule = ValidationRulePattern(pattern: "^0x([a-fA-F0-9]){40,40}$",
                                                      error: ValidationErrors.invalidWalletAddress)
        return value.validate(rule: walletAddressRule)
    }
}

final class NumberValidator: ValidatorConvertible {
    func validated(_ value: String) -> ValidationResult {
        let numberRule = ValidationRulePattern(pattern: "^(\\d+(\\.\\d+)?)$",
                                               error: ValidationErrors.notNumber)
        return value.validate(rule: numberRule)
    }
}

final class TransactionDataValidator: ValidatorConvertible {
    func validated(_ value: String) -> ValidationResult {
        let transactionDataRule = ValidationRulePattern(pattern: "^0x([a-fA-F0-9]){0,}$",
                                                        error: ValidationErrors.invalidTransactionData)
        return value.validate(rule: transactionDataRule)
    }
}
