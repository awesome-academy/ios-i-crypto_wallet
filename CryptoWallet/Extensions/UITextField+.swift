//
//  UITextField+.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/2/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func underlined(height: CGFloat, color: UIColor) {
        let underline = CALayer()
        underline.backgroundColor = color.cgColor
        underline.frame = CGRect(x: 0, y: frame.size.height - height, width: frame.width, height: height)
        layer.addSublayer(underline)
        layer.masksToBounds = true
    }
}
