//
//  UIButton+.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/1/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func borderButton(cornerRadius: CGFloat = 0, borderWidth: CGFloat = 0, borderColor: CGColor?) {
        self.layer.borderColor = borderColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
}
