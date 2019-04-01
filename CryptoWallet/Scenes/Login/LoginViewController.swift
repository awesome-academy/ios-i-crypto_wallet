//
//  LoginViewController.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/1/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import UIKit
import Then

final class LoginViewController: UIViewController {
    @IBOutlet private weak var createButton: UIButton!
    @IBOutlet private weak var recoverButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createButton.borderButton(cornerRadius: 5, borderWidth: 2, borderColor: UIColor.darkGray.cgColor)
        recoverButton.borderButton(cornerRadius: 5, borderWidth: 2, borderColor: UIColor.darkGray.cgColor)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction private func createButtonClick(_ sender: Any) {
    }
    
    @IBAction private func recoverButtonClick(_ sender: Any) {
    }
}
