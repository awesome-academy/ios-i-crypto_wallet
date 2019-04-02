//
//  Errors.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/2/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import Foundation

enum ValidationErrors: Error {
    case invalidPassword
    case notSamePassword
    case emptyPassword
}

extension ValidationErrors: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidPassword:
            return """
            Invalid password! Passwords must be between 8 and 16 characters long,
            contain at least one capital letter, a number, and a special character.
            """
        case .notSamePassword:
            return "Repeat password does not match password."
        case .emptyPassword:
            return "Password is empty"
        }
    }
}

enum EthereumInteractionErrors: Error {
    case cantCreateWallet
}

extension EthereumInteractionErrors: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .cantCreateWallet:
            return "Error while creating wallet!"
        }
    }
}
