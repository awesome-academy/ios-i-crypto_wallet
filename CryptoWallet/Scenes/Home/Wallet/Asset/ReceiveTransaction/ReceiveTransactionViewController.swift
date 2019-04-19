//
//  ReceiveTransactionViewController.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/12/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import UIKit
import Reusable

final class ReceiveTransactionViewController: UIViewController {
    @IBOutlet private weak var assetNameLabel: UILabel!
    @IBOutlet private weak var assetDescriptionLabel: UILabel!
    @IBOutlet private weak var qrCodeImage: UIImageView!
    @IBOutlet private weak var plusAmountLabel: UILabel!
    @IBOutlet private weak var plusAmountView: UIView!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var copyButton: UIButton!
    
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
        let shareButton = UIBarButtonItem(image: UIImage(named: "share-icon"),
                                          style: .done,
                                          target: self,
                                          action: #selector(handleShareButtonTapped(_:)))
        guard let assetInfo = assetInfo, let wallet = Wallet.sharedWallet else {
            return
        }
        navigationItem.do {
            $0.title = "Receive \(assetInfo.symbol)"
            $0.rightBarButtonItem = shareButton
        }
        assetNameLabel.do {
            $0.text = assetInfo.name
        }
        assetDescriptionLabel.do {
            $0.text = "My Public Address to Receive \(assetInfo.symbol)"
        }
        addressLabel.do {
            $0.text = wallet.walletAddress
        }
        qrCodeImage.do {
            $0.contentMode = .scaleToFill
            $0.image = generateQRCode(address: wallet.walletAddress, amount: "1")
        }
        addAmountToQRCode(amount: 1)
    }
    
    @IBAction private func handleEnterAmountButtonTapped(_ sender: Any) {
    }
    
    @IBAction private func handleCopyButtonTapped(_ sender: Any) {
    }
    
    @objc private func handleShareButtonTapped(_ sender: Any) {
    }
    
    private func addAmountToQRCode(amount: Double) {
        plusAmountView.do {
            $0.isHidden = false
            $0.backgroundColor = .greenColor
            $0.setBorder(cornerRadius: 5, borderWidth: 0, borderColor: .white)
        }
        plusAmountLabel.do {
            guard let assetInfo = assetInfo else {
                return
            }
            $0.text = "+ " + amount.threeDecimals(with: assetInfo.symbol)
        }
    }
    
    private func generateQRCode(address: String, amount: String? = nil) -> UIImage? {
        var combineString = address
        if let amount = amount {
            combineString += "&amount=\(amount)"
        }
        let data = combineString.data(using: String.Encoding.ascii)
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else {
            return nil
        }
        qrFilter.setValue(data, forKey: "inputMessage")
        guard let qrImage = qrFilter.outputImage else {
            return nil
        }
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledQrImage = qrImage.transformed(by: transform)
        let context = CIContext()
        guard let cgImage = context.createCGImage(scaledQrImage, from: scaledQrImage.extent) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
}

extension ReceiveTransactionViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.wallet
}
