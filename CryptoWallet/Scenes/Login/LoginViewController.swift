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
        configView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
    }
    
    @IBAction private func handleCreateWalletTapped(_ sender: Any) {
    }
    
    @IBAction private func handleRecoverWalletTapped(_ sender: Any) {
    }
    
    private func configView() {
        [createWalletButton, recoverWalletButton].forEach {
            $0.setBorder(cornerRadius: 5, borderWidth: 2, borderColor: .darkGray)
        }
    }
}
