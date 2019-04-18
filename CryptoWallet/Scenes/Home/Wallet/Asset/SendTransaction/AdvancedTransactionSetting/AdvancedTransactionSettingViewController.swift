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
        
    }
}

extension AdvancedTransactionSettingViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.wallet
}
