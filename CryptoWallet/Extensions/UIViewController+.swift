//
//  UIViewController+.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 3/29/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlertView(title: String = Constants.appName, message: String?, cancelButton: String?, otherButtons: [String]? = nil, type: UIAlertController.Style = .alert, cancelAction: (() -> Void)? = nil, otherAction: ((Int) -> Void)? = nil) {
        let alertViewController = UIAlertController(title: title,
                                                    message: message,
                                                    preferredStyle: .alert)
        
        if let cancelButton = cancelButton {
            let cancelAction = UIAlertAction(title: cancelButton, style: .cancel, handler: { (_) in
                cancelAction?()
            })
            alertViewController.addAction(cancelAction)
        }
        
        if let otherButtons = otherButtons {
            for (index, otherButton) in otherButtons.enumerated() {
                let otherAction = UIAlertAction(title: otherButton, style: .default, handler: { (_) in
                                                    otherAction?(index)
                })
                alertViewController.addAction(otherAction)
            }
        }
        DispatchQueue.main.async {
            self.present(alertViewController, animated: true, completion: nil)
        }
    }
    
    func showErrorAlert(message: String?) {
        showAlertView(title: "Error", message: message, cancelButton: "OK")
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func showNavigationBar() {
        navigationController?.isNavigationBarHidden = false
    }
    
    func hideNavigationBar() {
        navigationController?.isNavigationBarHidden = true
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
