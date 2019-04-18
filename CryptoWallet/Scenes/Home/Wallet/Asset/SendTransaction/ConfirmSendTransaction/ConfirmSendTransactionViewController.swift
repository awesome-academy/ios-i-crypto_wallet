//
//  ConfirmSendTransactionViewController.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/16/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import UIKit
import Reusable

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
    }
    
    @objc private func handleAdvancedSettingButtonTapped(_ sender: Any) {
    }
}

extension ConfirmSendTransactionViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.wallet
}
