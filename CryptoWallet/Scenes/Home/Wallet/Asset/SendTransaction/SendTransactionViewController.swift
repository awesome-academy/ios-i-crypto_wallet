//
//  SendTransactionViewController.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/12/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import UIKit
import Reusable

final class SendTransactionViewController: UIViewController {
    @IBOutlet private weak var recipientAddressTextField: UITextField!
    @IBOutlet private weak var amountTextField: UITextField!
    @IBOutlet private weak var recipientAddressView: UIView!
    @IBOutlet private weak var amountView: UIView!
    @IBOutlet private weak var conversionValueLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var maxButton: UIButton!
    
    var assetInfo: AssetInfo?
    private var amountEther = 0.0
    private var amountToken = 0.0
    private var valueType: ValueType = .asset
    private var gasPrice = 0.0
    
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
        let nextBarButton = UIBarButtonItem(title: "Next",
                                            style: .done,
                                            target: self,
                                            action: #selector(handleNextButtonTapped(_:)))
        navigationItem.do {
            guard let assetInfo = assetInfo else {
                return
            }
            $0.title = "Send \(assetInfo.symbol)"
            $0.rightBarButtonItem = nextBarButton
        }
        [recipientAddressView, amountView].forEach {
            $0.setBorder(cornerRadius: 5, borderWidth: 1, borderColor: .darkGray)
        }
        nextButton.do {
            $0.setBorder(cornerRadius: 5, borderWidth: 0, borderColor: .white)
        }
        amountTextField.do {
            guard let assetInfo = assetInfo else {
                return
            }
            $0.placeholder = "Amount " + assetInfo.symbol
        }
    }
    
    private func validate() -> Bool {
        let addressValidator = ValidatorFactory.validatorFor(type: .walletAddress)
        guard let address = recipientAddressTextField.text else {
            showErrorAlert(message: ValidationErrors.invalidWalletAddress.localizedDescription)
            recipientAddressView.setBorder(cornerRadius: 5, borderWidth: 1, borderColor: .red)
            return false
        }
        switch addressValidator.validated(address) {
        case .valid:
            recipientAddressView.setBorder(cornerRadius: 5, borderWidth: 1, borderColor: .darkGray)
            guard let amount = amountTextField.text, !amount.isEmpty else {
                showErrorAlert(message: ValidationErrors.required.localizedDescription)
                amountView.setBorder(cornerRadius: 5, borderWidth: 1, borderColor: .red)
                return false
            }
            let amountValidator = ValidatorFactory.validatorFor(type: .amount)
            switch amountValidator.validated(amount) {
            case .valid:
                amountView.setBorder(cornerRadius: 5, borderWidth: 1, borderColor: .darkGray)
                return true
            case .invalid(let errors):
                showErrorAlert(message: errors.first?.localizedDescription)
                amountView.setBorder(cornerRadius: 5, borderWidth: 1, borderColor: .red)
                return false
            }
        case .invalid(let errors):
            showErrorAlert(message: errors.first?.localizedDescription)
            recipientAddressView.setBorder(cornerRadius: 5, borderWidth: 1, borderColor: .red)
            return false
        }
    }
    
    @IBAction private func handleNextButtonTapped(_ sender: Any) {
        if validate() {
            let confirmSendTransactionController = ConfirmSendTransactionViewController.instantiate()
            navigationController?.pushViewController(confirmSendTransactionController, animated: true)
        }
    }
    
    @IBAction private func handlePasteButtonTapped(_ sender: Any) {
        if let copiedAddress = UIPasteboard.general.string {
            recipientAddressTextField.do {
                $0.text = copiedAddress
            }
        }
    }
    
    @IBAction private func handleScanQRTapped(_ sender: Any) {
        let scanQRController = ScanQRViewController.instantiate()
        navigationController?.pushViewController(scanQRController, animated: true)
    }
    
    @IBAction private func handleMaxButtonTapped(_ sender: Any) {
        var estimatedFee = 0.0
        guard let assetInfo = assetInfo else {
            return
        }
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.global(qos: .userInteractive).async {
            guard let (fee, gasPrice) = EthereumInteraction.getEstimatedFee() else {
                group.leave()
                return
            }
            estimatedFee = fee
            self.gasPrice = gasPrice
            group.leave()
        }
        group.notify(queue: .main) {
            self.amountTextField.do {
                $0.text = assetInfo.type == .coin ? "\(assetInfo.amount - estimatedFee)" : "\(assetInfo.amount)"
            }
            self.handleAmountValueChanged(self.amountTextField)
            if assetInfo.type == .coin {
                self.amountEther = assetInfo.amount - estimatedFee
            } else {
                self.amountEther = estimatedFee
                self.amountToken = assetInfo.amount
            }
        }
    }
    
    @IBAction private func handleChangeValueTypeTapped(_ sender: UIButton) {
        guard let assetInfo = assetInfo else {
            return
        }
        valueType = valueType == .asset ? .usd : .asset
        maxButton.do {
            $0.isHidden = !(valueType == .asset)
        }
        sender.do {
            $0.setTitle(valueType == .asset ? "USD" : assetInfo.symbol, for: .normal)
        }
        amountTextField.do {
            $0.placeholder = "Amount " + (valueType == .usd ? "USD" : assetInfo.symbol)
        }
    }
    
    @IBAction private func handleAmountValueChanged(_ sender: UITextField) {
        if let assetInfo = assetInfo,
            let amountString = sender.text,
            let amount = Double(amountString) {
            self.conversionValueLabel.do {
                $0.text = valueType == .asset ?
                "~" + (amount * assetInfo.price).threeDecimals(with: "USD"):
                "~" + (amount / assetInfo.price).threeDecimals(with: assetInfo.symbol)
            }
        } else {
            self.conversionValueLabel.do {
                $0.text = ""
            }
        }
    }
}

extension SendTransactionViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.wallet
}
