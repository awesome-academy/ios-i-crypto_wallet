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
    
    func underlined(height: CGFloat, color: UIColor) {
        let underline = CALayer().then {
            $0.backgroundColor = color.cgColor
            $0.frame = CGRect(x: 0, y: frame.size.height - height, width: frame.width, height: height)
        }
        layer.addSublayer(underline)
        layer.masksToBounds = true
    }
}
