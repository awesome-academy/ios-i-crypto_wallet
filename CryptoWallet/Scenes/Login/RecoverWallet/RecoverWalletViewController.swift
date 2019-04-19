//
//  RecoverWalletViewController.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/2/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import UIKit
import Reusable
import Then
import UITextView_Placeholder
import Valet

final class RecoverWalletViewController: UIViewController {
    @IBOutlet private weak var recoveryDataTextView: UITextView!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var repeatPasswordTextField: UITextField!
    @IBOutlet private weak var recoverWalletButton: UIButton!
    @IBOutlet private weak var guideButton: UIButton!
    @IBOutlet private weak var recoverWalletNoticeLabel: UILabel!
    @IBOutlet private weak var walletNameTextField: UITextField!
    @IBOutlet weak var methodTabSegmentControl: UISegmentedControl!
    
    private var validatedPassword = ""
    private var validatedRecoveryData = ""
    private let cronJobRepository: CronJobRepository = CronJobRepositoryImpl(api:
        APIService(adapterRequest: CustomRequestAdapter()))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    @IBAction private func handleRecoverWalletTapped(_ sender: Any) {
        if validate() {
            do {
                var walletName = Constants.appName
                if let wallet = walletNameTextField.text, !wallet.isEmpty {
                    walletName = wallet
                }
                let wallet = methodTabSegmentControl.selectedSegmentIndex == 0 ?
                    try EthereumInteraction.importWalletByMnenomic(walletName: walletName,
                                                                   mnenomicPhrase: validatedRecoveryData,
                                                                   password: validatedPassword) :
                    try EthereumInteraction.importWalletByPrivateKey(walletName: walletName,
                                                                     privateKey: validatedRecoveryData,
                                                                     password: validatedPassword)
                guard let id = Identifier(nonEmpty: Constants.appName) else {
                    throw SessionErrors.cantCreateIdentifier
                }
                Valet.valet(with: id, accessibility: .whenUnlockedThisDeviceOnly).do {
                    $0.set(string: "\(methodTabSegmentControl.selectedSegmentIndex):\(validatedRecoveryData)",
                           forKey: Constants.recoveryDataKey)
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
                let homeTabBarController = HomeTabBarController.instantiate()
                present(homeTabBarController, animated: true, completion: nil)
            } catch {
                showErrorAlert(message: error.localizedDescription)
            }
        }
    }
    
    @IBAction private func handleGuideTapped(_ sender: Any) {
        let webViewController = WebViewController.instantiate()
        navigationController?.pushViewController(webViewController, animated: true)
    }
    
    @IBAction func handleRecoverMethodTabChanged(_ sender: UISegmentedControl) {
        let methodName = sender.titleForSegment(at: sender.selectedSegmentIndex) ?? "Mnenomic Phrase"
        recoverWalletNoticeLabel.do {
            $0.text = "You can reset the password while importing the \(methodName)."
        }
        guideButton.do {
            $0.setTitle("What is a \(methodName)?", for: .normal)
        }
        recoveryDataTextView.do {
            $0.placeholder = methodName
        }
    }
    
    private func configView() {
        recoveryDataTextView.setBorder(cornerRadius: 5, borderWidth: 1, borderColor: .lightGray)
        recoverWalletButton.setBorder(cornerRadius: 5, borderWidth: 0, borderColor: .white)
        let headerLine = CALayer().then {
            $0.frame = CGRect(x: 0, y: 0, width: guideButton.frame.width, height: 1)
            $0.backgroundColor = UIColor.lightGray.cgColor
        }
        guideButton.do {
            $0.tintColor = UIColor(red: 0.00, green: 0.53, blue: 1.00, alpha: 1.0)
            $0.layer.addSublayer(headerLine)
            $0.setImage(UIImage(named: "book-icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.contentMode = .scaleAspectFit
        }
        [passwordTextField, repeatPasswordTextField, walletNameTextField].forEach {
            $0.underlined(height: 1, color: .lightGray)
        }
        recoveryDataTextView.do {
            $0.placeholder = "Mnenomic Phrase"
            $0.placeholderColor = .lightGray
        }
    }
    
    private func validate() -> Bool {
        let passwordValidator = ValidatorFactory.validatorFor(type: .password)
        let recoverDataValidator = methodTabSegmentControl.selectedSegmentIndex == 0 ?
            ValidatorFactory.validatorFor(type: .mnenomicPhrase) : ValidatorFactory.validatorFor(type: .privateKey)
        guard let recoveryData = recoveryDataTextView.text else {
            showErrorAlert(message: ValidationErrors.emptyRecoveryData.localizedDescription)
            return false
        }
        guard let password = passwordTextField.text, let repeatPassword = repeatPasswordTextField.text else {
            showErrorAlert(message: ValidationErrors.emptyPassword.localizedDescription)
            return false
        }
        switch recoverDataValidator.validated(recoveryData) {
        case .valid:
            recoveryDataTextView.setBorder(cornerRadius: 5, borderWidth: 1, borderColor: .lightGray)
            validatedRecoveryData = recoveryData
            switch passwordValidator.validated(password) {
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
        case .invalid(let errors):
            recoveryDataTextView.setBorder(cornerRadius: 5, borderWidth: 1, borderColor: .red)
            showErrorAlert(message: errors.first?.localizedDescription)
            return false
        }
    }
}

extension RecoverWalletViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
