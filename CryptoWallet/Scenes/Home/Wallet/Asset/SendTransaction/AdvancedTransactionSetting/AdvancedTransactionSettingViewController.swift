//
//  AdvancedTransactionSettingViewController.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/17/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import UIKit
import Reusable
import BigInt
import Web3swift

final class AdvancedTransactionSettingViewController: UIViewController {
    @IBOutlet private weak var gasPriceTextField: UITextField!
    @IBOutlet private weak var gasLimitTextField: UITextField!
    @IBOutlet private weak var transactionDataTextField: UITextField!
    
    var gasPrice = 0.0
    var gasLimit: BigUInt = 0
    var transactionData = Data()
    var onCompletion: ((_ gasPrice: Double, _ gasLimit: BigUInt, _ transactionData: Data) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    private func configView() {
        navigationController?.navigationBar.do {
            $0.barTintColor = .blueColor
            $0.tintColor = .white
            $0.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        }
        let saveButton = UIBarButtonItem(title: "Save",
                                         style: .done,
                                         target: self,
                                         action: #selector(handleSaveButtonTapped(_:)))
        navigationItem.do {
            $0.title = "Advanced Setting"
            $0.rightBarButtonItem = saveButton
        }
        [gasPriceTextField, gasLimitTextField, transactionDataTextField].forEach {
            $0?.underlined(height: 1, color: .lightGray)
        }
        gasPriceTextField.do {
            $0.text = Web3.Utils.formatToEthereumUnits(BigInt(gasPrice), toUnits: .Gwei, decimals: 3)
        }
        gasLimitTextField.do {
            $0.text = String(gasLimit)
        }
        transactionDataTextField.text = "0x" + transactionData.toHexString()
    }
    
    @objc private func handleSaveButtonTapped(_ sender: Any) {
        if validate() {
            guard let gasPriceString = gasPriceTextField.text,
                var newGasPrice = Double(gasPriceString),
                let gasLimitString = gasLimitTextField.text,
                let newGasLimit = BigUInt(gasLimitString),
                let rawDataString = transactionDataTextField.text else {
                    return
            }
            newGasPrice = newGasPrice * pow(10, 9)
            var newTransactionData = Data()
            let hexSubString = rawDataString.split(separator: "x")
            if hexSubString.count > 1 {
                let hexString = String(hexSubString[1])
                print(hexString)
                newTransactionData = Data(hex: hexString)
            }
            onCompletion?(newGasPrice, newGasLimit, newTransactionData)
            navigationController?.popViewController(animated: true)
        }
    }
    
    private func validate() -> Bool {
        guard let gasPrice = gasPriceTextField.text,
            let gasLimit = gasLimitTextField.text,
            let transactionData = transactionDataTextField.text else {
                return false
        }
        let numberValidator = ValidatorFactory.validatorFor(type: .number)
        switch numberValidator.validated(gasPrice) {
        case .valid:
            gasPriceTextField.do {
                $0.underlined(height: 1, color: .lightGray)
            }
            switch numberValidator.validated(gasLimit) {
            case .valid:
                gasLimitTextField.do {
                    $0.underlined(height: 1, color: .lightGray)
                }
                let transactionDataValidator = ValidatorFactory.validatorFor(type: .transactionData)
                switch transactionDataValidator.validated(transactionData) {
                case .valid:
                    transactionDataTextField.do {
                        $0.underlined(height: 1, color: .lightGray)
                    }
                    return true
                case .invalid(let errors):
                    transactionDataTextField.do {
                        $0.underlined(height: 1, color: .red)
                    }
                    showErrorAlert(message: errors.first?.localizedDescription)
                    return false
                }
            case .invalid(let errors):
                gasLimitTextField.do {
                    $0.underlined(height: 1, color: .red)
                }
                showErrorAlert(message: errors.first?.localizedDescription)
                return false
            }
        case .invalid(let errors):
            gasPriceTextField.do {
                $0.underlined(height: 1, color: .red)
            }
            showErrorAlert(message: errors.first?.localizedDescription)
            return false
        }
    }
}

extension AdvancedTransactionSettingViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.wallet
}
