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
                let backupNoticeController = BackupNoticeViewController.instantiate().then {
                    $0.wallet = wallet
                }
                navigationController?.pushViewController(backupNoticeController, animated: true)
            } catch {
                
            }
        }
    }
    
    private func configView() {
        [walletNameTextField, passwordTextField, repeatPasswordTextField].forEach {
            $0?.underlined(height: 1, color: .lightGray)
        }
    }
    
    private func validate() -> Bool {
        do {
            validatedPassword = try passwordTextField.validatedText(validationType: .password)
            passwordTextField.do {
                $0.underlined(height: 1, color: .lightGray)
            }
            if validatedPassword == repeatPasswordTextField.text {
                repeatPasswordTextField.do {
                    $0.underlined(height: 1, color: .lightGray)
                }
                return true
            } else {
                showErrorAlert(message: "Repeat password is not match password!")
                repeatPasswordTextField.do {
                    $0.underlined(height: 1, color: .red)
                }
                return false
            }
        } catch ValidationErrors.invalidPassword {
            showErrorAlert(message: ValidationErrors.invalidPassword.localizedDescription)
            passwordTextField.do {
                $0.underlined(height: 1, color: .red)
            }
            return false
        } catch {
            showErrorAlert(message: error.localizedDescription)
            passwordTextField.do {
                $0.underlined(height: 1, color: .red)
            }
            return false
        }
    }
}

extension CreateWalletViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
