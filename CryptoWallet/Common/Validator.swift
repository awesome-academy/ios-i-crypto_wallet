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
    func validatedEquality(_ firstValue: String, _ secondValue: String) -> ValidationResult
}

enum ValidatorType {
    case password
}

enum ValidatorFactory {
    static func validatorFor(type: ValidatorType) -> ValidatorConvertible {
        switch type {
        case .password:
            return PasswordValidator()
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
