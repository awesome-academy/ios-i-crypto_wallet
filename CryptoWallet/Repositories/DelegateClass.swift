//
//  DelegateClass.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/18/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import Foundation
import Web3swift

final class DelegateClass: Web3SocketDelegate {
    var socketProvider: InfuraWebsocketProvider?
    
    func received(message: Any) {
        print(message)
    }
    
    func gotError(error: Error) {
        print(error.localizedDescription)
    }
}
