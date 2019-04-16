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
    private let cronJobRepository: CronJobRepository = CronJobRepositoryImpl(api:
        APIService(adapterRequest: CustomRequestAdapter()))

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    @IBAction private func handleCreateWalletTapped(_ sender: Any) {
        if validate() {
            do {
                var walletName = Constants.appName
                if let wallet = walletNameTextField.text, !wallet.isEmpty {
                    walletName = wallet
                }
                let (wallet, mnonemics) = try EthereumInteraction.createNewWallet(
                    name: walletName,
                    password: validatedPassword)
                guard let id = Identifier(nonEmpty: Constants.appName) else {
                    throw SessionErrors.cantCreateIdentifier
                }
                Valet.valet(with: id, accessibility: .whenUnlockedThisDeviceOnly).do {
                    $0.set(string: "0:" + mnonemics, forKey: Constants.recoveryDataKey)
                    $0.set(string: validatedPassword, forKey: Constants.passwordKey)
                    $0.set(string: wallet.walletName, forKey: Constants.walletNameKey)
                }
                cronJobRepository.checkWallet(address: wallet.walletAddress) { (result) in
                    switch result {
                    case .success(let checkCronJobResponse):
                        if let checkCronJobResponse = checkCronJobResponse,
                            checkCronJobResponse.description.contains(CronJobAPI.notExistEvent) {
                            self.cronJobRepository.trackWallet(address: wallet.walletAddress) { (result) in
                                switch result {
                                case .success(let cronJobResponse):
                                    if let cronJobResponse = cronJobResponse {
                                        print(cronJobResponse.id)
                                    }
                                case .failure(let error):
                                    if let errorMessage = error?.errorMessage {
                                        print(errorMessage)
                                    }
                                }
                            }
                        }
                    case .failure(let error):
                        if let errorMessage = error?.errorMessage {
                            print(errorMessage)
                        }
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
            switch PasswordValidator().validatedEquality(password, repeatPassword) {
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
