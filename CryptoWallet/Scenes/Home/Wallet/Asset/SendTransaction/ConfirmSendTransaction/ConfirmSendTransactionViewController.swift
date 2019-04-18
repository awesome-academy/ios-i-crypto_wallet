//
//  ConfirmSendTransactionViewController.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/16/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import UIKit
import Reusable
import Web3swift
import BigInt

final class ConfirmSendTransactionViewController: UIViewController {
    @IBOutlet private weak var transactionTypeImage: UIImageView!
    @IBOutlet private weak var amountLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!
    @IBOutlet private weak var fromLabel: UILabel!
    @IBOutlet private weak var toLabel: UILabel!
    @IBOutlet private weak var networkFeeLabel: UILabel!
    @IBOutlet private weak var totalValueLabel: UILabel!
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var fromView: UIView!
    @IBOutlet private weak var toView: UIView!
    @IBOutlet private weak var networkFeeView: UIView!
    @IBOutlet private weak var maxTotalView: UIView!
    @IBOutlet private weak var sendButton: UIButton!
    
    var assetInfo: AssetInfo?
    var amount = 0.0
    var gasPrice = 0.0
    var gasLimit: BigUInt = 0
    var toAddress = ""
    var etherPrice = 0.0
    private var assetRepository: AssetRepository = AssetRepositoryImpl(api: APIService.share)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configLoading()
    }
    
    private func configView() {
        navigationController?.navigationBar.do {
            $0.barTintColor = .blueColor
            $0.tintColor = .white
            $0.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        }
        let advancedSettingButton = UIBarButtonItem(image: UIImage(named: "setting-icon"),
                                                    style: .done,
                                                    target: self,
                                                    action: #selector(handleAdvancedSettingButtonTapped(_:)))
        navigationItem.do {
            $0.title = "Confirm"
            $0.rightBarButtonItem = advancedSettingButton
        }
        [headerView, fromView, toView, networkFeeView, maxTotalView].forEach {
            $0?.underlined(height: 1, color: .lightGray)
        }
        transactionTypeImage.do {
            $0.setBorder(cornerRadius: $0.frame.width / 2, borderWidth: 1, borderColor: .lightGray)
        }
        sendButton.do {
            $0.setBorder(cornerRadius: 5, borderWidth: 0, borderColor: .white)
        }
        guard let assetInfo = assetInfo else {
            return
        }
        amountLabel.do {
            $0.text = assetInfo.type == .coin ?
                amount.threeDecimals(with: "ETH") :
                amount.threeDecimals(with: assetInfo.symbol)
        }
        valueLabel.do {
            $0.text = "($" + (assetInfo.price * amount).threeDecimals() + ")"
        }
        if let wallet = Wallet.sharedWallet {
            let firstCharacters = wallet.walletAddress.prefix(12)
            let lastCharacters = wallet.walletAddress.suffix(12)
            fromLabel.do {
                $0.text = wallet.walletName + "(\(firstCharacters)...\(lastCharacters))"
            }
        }
        toLabel.do {
            $0.text = toAddress
        }
    }
    
    @objc private func handleAdvancedSettingButtonTapped(_ sender: Any) {
        let advancedTransactionSettingController = AdvancedTransactionSettingViewController.instantiate()
        navigationController?.pushViewController(advancedTransactionSettingController, animated: true)
    }
    
    @IBAction func handleSendButtonTapped(_ sender: Any) {
        guard let assetInfo = assetInfo else {
            return
        }
        let alert = UIAlertController(title: "Password", message: "Enter your wallet password", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Wallet Password"
            textField.isSecureTextEntry = true
        }
        let confirmButton = UIAlertAction(title: "Confirm", style: .default) { [weak self] (_) in
            guard let password = alert.textFields?[0].text, let self = self else {
                return
            }
            self.view.showOverlayIndicator()
            DispatchQueue.global(qos: .userInteractive).async {
                do {
                    let newTransaction = Transaction()
                    let delegate = DelegateClass()
                    EthereumInteraction.subscribePendingTransaction(forDelegate: delegate)
                    let result = (assetInfo.type == .coin ?
                        try EthereumInteraction.sendEther(toAddress: self.toAddress,
                                                          value: self.amount,
                                                          gasPrice: self.gasPrice,
                                                          gasLimit: Double(self.gasLimit),
                                                          password: password) :
                        try EthereumInteraction.sendERC20Token(smartContract: assetInfo.smartContractAddress,
                                                               toAddress: self.toAddress,
                                                               value: self.amount,
                                                               gasPrice: self.gasPrice,
                                                               gasLimit: Double(self.gasLimit),
                                                               password: password))
                    if let result = result {
                        guard let wallet = Wallet.sharedWallet else {
                            return
                        }
                        newTransaction.id = result.hash
                        newTransaction.from = wallet.walletAddress
                        newTransaction.to = self.toAddress
                        newTransaction.value = String(self.amount * pow(10, assetInfo.decimals))
                        newTransaction.timeStamp = String(Date().timeIntervalSince1970)
                        if assetInfo.type == .token {
                            newTransaction.to = assetInfo.smartContractAddress
                            newTransaction.value = "0"
                            let newContractOperation = ContractOperation()
                            newContractOperation.to = self.toAddress
                            newContractOperation.from = wallet.walletAddress
                            newContractOperation.value = String(self.amount * pow(10, assetInfo.decimals))
                            newTransaction.contractOperation = newContractOperation
                        }
                        if let viewControllers = self.navigationController?.viewControllers {
                            for viewController in viewControllers where viewController is AssetViewController {
                                DispatchQueue.main.async {
                                    self.view.hideOverlayIndicator()
                                    guard let assetViewController = viewController as? AssetViewController else {
                                        return
                                    }
                                    assetViewController.newTransaction = newTransaction
                                    self.navigationController?.popToViewController(assetViewController, animated: false)
                                }
                                break
                            }
                        }
                    }
                } catch Web3Error.inputError(let error) {
                    DispatchQueue.main.async {
                        self.view.hideOverlayIndicator()
                    }
                    self.showErrorAlert(message: error)
                } catch Web3Error.processingError(let error) {
                    DispatchQueue.main.async {
                        self.view.hideOverlayIndicator()
                    }
                    self.showErrorAlert(message: error)
                } catch {
                    DispatchQueue.main.async {
                        self.view.hideOverlayIndicator()
                    }
                    self.showErrorAlert(message: error.localizedDescription)
                }
            }
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(confirmButton)
        alert.addAction(cancelButton)
        present(alert, animated: true, completion: nil)
    }
    
    private func configLoading() {
        guard let assetInfo = assetInfo else {
            return
        }
        view.showOverlayIndicator()
        DispatchQueue.global(qos: .userInteractive).async {
            if !self.checkETHBalance() {
                DispatchQueue.main.async {
                    self.sendButton.do {
                        $0.setTitle("Insufficient ETH balance", for: .normal)
                        $0.backgroundColor = .gray
                        $0.isEnabled = false
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.sendButton.do {
                        $0.setTitle("Send", for: .normal)
                        $0.backgroundColor = .blueColor
                        $0.isEnabled = true
                    }
                }
            }
            self.gasLimit = (assetInfo.type == .coin ? Constants.gasLimitEtherDefault : Constants.gasLimitTokenDefault)
            let fee = Double(self.gasLimit) * self.gasPrice
            self.etherPrice = self.getEtherPrice()
            if let etherFee = Web3.Utils.formatToEthereumUnits(BigInt(fee), toUnits: .eth, decimals: 6),
                let etherFeeDouble = Double(etherFee) {
                DispatchQueue.main.async {
                    self.networkFeeLabel.do {
                        $0.text = etherFee + " ETH ($" + (etherFeeDouble * self.etherPrice).threeDecimals() + ")"
                    }
                    self.totalValueLabel.do {
                        $0.text = "$" + (assetInfo.price * self.amount +
                            etherFeeDouble * self.etherPrice).threeDecimals()
                    }
                    self.view.hideOverlayIndicator()
                }
            }
        }
    }
    
    private func getEtherPrice() -> Double {
        var etherPrice = 0.0
        let group = DispatchGroup()
        group.enter()
        assetRepository.getEthereumInfo { (result) in
            switch result {
            case .success(let etherInfoResponse):
                guard let etherInfoResponse = etherInfoResponse else {
                    group.leave()
                    return
                }
                etherPrice = etherInfoResponse.price
                group.leave()
            case .failure(error: _):
                group.leave()
                return
            }
        }
        group.wait()
        return etherPrice
    }
    
    private func checkETHBalance() -> Bool {
        guard let wallet = Wallet.sharedWallet, let assetInfo = assetInfo else {
            return false
        }
        let group = DispatchGroup()
        var etherBalance = 0.0
        var tokenBalance = 0.0
        group.enter()
        DispatchQueue.global(qos: .userInteractive).async {
            guard let balance = EthereumInteraction.getEtherBalance(address: wallet.walletAddress),
                let etherBalanceDouble = Double(balance) else {
                group.leave()
                return
            }
            etherBalance = etherBalanceDouble
            if assetInfo.type != .coin {
                guard let tokenBalanceDouble = EthereumInteraction.getERC20TokenBalance(
                    contractAddress: assetInfo.smartContractAddress,
                    walletAddress: wallet.walletAddress) else {
                        group.leave()
                        return
                }
                tokenBalance = tokenBalanceDouble / pow(10, assetInfo.decimals)
            }
            if self.gasPrice == 0.0 {
                guard let (_, gasPrice) = EthereumInteraction.getEstimatedFee(assetInfo.type) else {
                        group.leave()
                        return
                }
                self.gasPrice = gasPrice
            }
            group.leave()
        }
        group.wait()
        self.gasLimit = (assetInfo.type == .coin ? Constants.gasLimitEtherDefault : Constants.gasLimitTokenDefault)
        let totalFee = (gasPrice * Double(gasLimit)) / pow(10, 18)
        print(totalFee)
        if assetInfo.type == .coin {
            if etherBalance >= (totalFee + amount) {
                return true
            }
        } else {
            if etherBalance >= totalFee, tokenBalance >= amount {
                return true
            }
        }
        return false
    }
}

extension ConfirmSendTransactionViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.wallet
}
