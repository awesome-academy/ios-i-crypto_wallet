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
    
    func showOverlayIndicator(style: UIActivityIndicatorView.Style = .whiteLarge) {
        let activity = UIActivityIndicatorView().then {
            $0.style = style
            $0.startAnimating()
        }
        let overlayView = UIView().then {
            $0.frame = frame
            $0.backgroundColor = .black
            $0.alpha = 0.3
            $0.tag = Constants.indicatorTag
            $0.addSubview(activity)
        }
        activity.do {
            $0.center = overlayView.center
        }
        addSubview(overlayView)
    }
    
    func hideOverlayIndicator() {
        let overlayView = viewWithTag(Constants.indicatorTag)
        overlayView?.removeFromSuperview()
    }
}
