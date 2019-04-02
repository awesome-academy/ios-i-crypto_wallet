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
    
    var localizedDescription: String {
        switch self {
        case .invalidPassword:
            return """
            Invalid password! Password must be greater or equal 8 characters
            and contain at least 1 uppercase word, 1 lowercase word,
            1 number and 1 special word.
            """
        }
    }
}

enum EthereumInteractionErrors: Error {
    enum walletCreatingErrors: Error {
        case cantCreateWallet
        
        var localizedDescription: String {
            switch self {
            case .cantCreateWallet:
                return "Error while creating wallet!"
            }
        }
    }
}
