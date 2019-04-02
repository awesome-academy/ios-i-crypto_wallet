//
//  CreateWalletViewController.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/2/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import UIKit
import Reusable

final class CreateWalletViewController: UIViewController {
    @IBOutlet private weak var walletNameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var repeatPasswordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    @IBAction private func handleCreateWalletTapped(_ sender: Any) {
    }
    
    private func configView() {
        [walletNameTextField, passwordTextField, repeatPasswordTextField].forEach {
            $0?.underlined(height: 1, color: .gray)
        }
    }
}

extension CreateWalletViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
