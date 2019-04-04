//
//  CreateWalletViewController.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/2/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import UIKit
import Reusable
import Valet
import Web3swift

final class CreateWalletViewController: UIViewController {
    @IBOutlet private weak var walletNameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var repeatPasswordTextField: UITextField!
    
    private var validatedPassword = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    @IBAction private func handleCreateWalletTapped(_ sender: Any) {
        if validate() {
            do {
                let (wallet, mnonemics) = try EthereumInteraction.createNewWallet(
                    name: walletNameTextField.text ?? Constants.appName,
                    password: validatedPassword)
                if let id = Identifier(nonEmpty: Constants.appName) {
                    Valet.valet(with: id, accessibility: .whenUnlockedThisDeviceOnly).do {
                        $0.set(string: mnonemics, forKey: "mnonemics")
                        $0.set(string: validatedPassword, forKey: "password")
                    }
                }
                Wallet.sharedWallet = wallet
                let backupNoticeController = BackupNoticeViewController.instantiate().then {
                    $0.mnonemics = mnonemics
                }
                navigationController?.pushViewController(backupNoticeController, animated: true)
            } catch {
                showErrorAlert(message: error.localizedDescription)
            }
        }
    }
    
    private func configView() {
        [walletNameTextField, passwordTextField, repeatPasswordTextField].forEach {
            $0?.underlined(height: 1, color: .lightGray)
        }
    }
    
    private func validate() -> Bool {
        let validator = ValidatorFactory.validatorFor(type: .password)
        guard let password = passwordTextField.text, let repeatPassword = repeatPasswordTextField.text else {
            showErrorAlert(message: ValidationErrors.emptyPassword.localizedDescription)
            return false
        }
        switch validator.validated(password) {
        case .valid:
            passwordTextField.do {
                $0.underlined(height: 1, color: .lightGray)
            }
            switch validator.validatedEquality(password, repeatPassword) {
            case .valid:
                repeatPasswordTextField.do {
                    $0.underlined(height: 1, color: .lightGray)
                }
                validatedPassword = password
                return true
            case .invalid(let errors):
                repeatPasswordTextField.do {
                    $0.underlined(height: 1, color: .red)
                }
                showErrorAlert(message: errors.first?.localizedDescription)
                return false
            }
        case .invalid(let errors):
            passwordTextField.do {
                $0.underlined(height: 1, color: .red)
            }
            showErrorAlert(message: errors.first?.localizedDescription)
            return false
        }
    }
}

extension CreateWalletViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
