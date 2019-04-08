//
//  BaseResult.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/9/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import Foundation
import ObjectMapper

enum BaseResult<T: Mappable> {
    case success(T?)
    case failure(error: BaseError?)
}

enum BaseArrayResult<T: Mappable> {
    case success([T]?)
    case failure(error: BaseError?)
}
