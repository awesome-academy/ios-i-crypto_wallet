//
//  DataTransform.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/10/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import Foundation
import ObjectMapper

enum DataTransform {
    static let StringDouble = TransformOf<Double, String>(fromJSON: { (value: String?) -> Double? in
        if let value = value {
            return Double(value)
        }
        return nil
    }, toJSON: { (value: Double?) -> String? in
        if let value = value {
            return String(value)
        }
        return nil
    })
}
