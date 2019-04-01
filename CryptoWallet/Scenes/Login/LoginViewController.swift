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
    @IBOutlet private weak var createWalletButton: UIButton!
    @IBOutlet private weak var recoverWalletButton: UIButton!
    @IBOutlet private weak var importGuideLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [createWalletButton, recoverWalletButton].forEach { (button) in
            button?.setBorder(cornerRadius: 5, borderWidth: 2, borderColor: .darkGray)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction private func createWalletTapped(_ sender: Any) {
    }
    
    @IBAction private func recoverWalletTapped(_ sender: Any) {
    }
}
