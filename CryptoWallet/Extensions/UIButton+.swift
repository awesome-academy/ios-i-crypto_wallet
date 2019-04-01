//
//  UIButton+.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/1/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import Foundation
import UIKit
import Then

extension UIButton {
    func setBorder(cornerRadius: CGFloat = 0, borderWidth: CGFloat = 0, borderColor: UIColor) {
        _ = self.then {
            $0.layer.cornerRadius = cornerRadius
            $0.layer.borderColor = borderColor.cgColor
            $0.layer.borderWidth = borderWidth
            $0.clipsToBounds = true
        }
    }
}
