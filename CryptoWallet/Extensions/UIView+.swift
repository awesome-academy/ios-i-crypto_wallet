//
//  UIView+.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/1/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func setBorder(cornerRadius: CGFloat = 0, borderWidth: CGFloat = 0, borderColor: UIColor) {
        layer.cornerRadius = cornerRadius
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        clipsToBounds = true
    }
}
