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
    
    var assetInfo: AssetInfo?
    
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
        let nextButton = UIBarButtonItem(title: "NEXT",
                                         style: .done,
                                         target: self,
                                         action: #selector(handleNextButtonTapped(_:)))
        navigationItem.do {
            guard let assetInfo = assetInfo else {
                return
            }
            $0.title = "Send \(assetInfo.symbol)"
            $0.rightBarButtonItem = nextButton
            $0.backBarButtonItem = UIBarButtonItem(title: "Back",
                                                   style: .plain,
                                                   target: nil,
                                                   action: nil)
        }
        [recipientAddressView, amountView].forEach {
            $0.setBorder(cornerRadius: 5, borderWidth: 1, borderColor: .darkGray)
        }
    }
    
    @objc private func handleNextButtonTapped(_ sender: Any) {
    }
    
    @IBAction private func handlePasteButtonTapped(_ sender: Any) {
    }
    
    @IBAction private func handleScanQRTapped(_ sender: Any) {
    }
    
    @IBAction private func handleMaxButtonTapped(_ sender: Any) {
    }
    
    @IBAction private func handleChangeValueTypeTapped(_ sender: Any) {
    }
}

extension SendTransactionViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.wallet
}
