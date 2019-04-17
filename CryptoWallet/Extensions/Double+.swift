//
//  Double+.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/17/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import Foundation

extension Double {
    func twoDecimals(with string: String? = nil) -> String {
        if let string = string {
            return String(format: "%.2f %@", self, string)
        }
        return String(format: "%.2f", self)
    }
    
    func threeDecimals(with string: String? = nil) -> String {
        if let string = string {
            return String(format: "%.3f %@", self, string)
        }
        return String(format: "%.3f", self)
    }

    func fourDecimals(with string: String? = nil) -> String {
        if let string = string {
            return String(format: "%.4f %@", self, string)
        }
        return String(format: "%.4f", self)
    }
}
