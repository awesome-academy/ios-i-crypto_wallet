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
            $0.image = generateQRCode(address: wallet.walletAddress)
        }
        copyButton.do {
            $0.setBorder(cornerRadius: 5, borderWidth: 0, borderColor: .white)
        }
    }
    
    @IBAction private func handleEnterAmountButtonTapped(_ sender: Any) {
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let alert = UIAlertController(title: "Enter Amount", message: nil, preferredStyle: .alert).then {
            $0.addTextField { (textField) in
                textField.placeholder = "Amount"
                textField.keyboardType = .decimalPad
            }
            $0.addAction(cancelButton)
        }
        let confirmButton = UIAlertAction(title: "Confirm", style: .default) { [weak self] (_) in
            guard let self = self,
                let amountString = alert.textFields?[0].text,
                let amount = Double(amountString),
                let wallet = Wallet.sharedWallet else {
                return
            }
            self.qrCodeImage.do {
                $0.image = self.generateQRCode(address: wallet.walletAddress, amount: amountString)
            }
            self.addAmountToQRCode(amount: amount)
        }
        alert.addAction(confirmButton)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction private func handleCopyButtonTapped(_ sender: Any) {
        guard let address = Wallet.sharedWallet?.walletAddress else {
            return
        }
        UIPasteboard.general.string = address
        view.makeToast("Address copied")
    }
    
    @objc private func handleShareButtonTapped(_ sender: Any) {
        guard let assetInfo = assetInfo, let wallet = Wallet.sharedWallet else {
            return
        }
        let stringItem = """
                         My Public Address to Receive \(assetInfo.symbol):
                         \(wallet.walletAddress)
                         """
        
        var imageItem = UIImage()
        if let image = qrCodeImage.image {
            imageItem = image
        }
        let items: [Any] = [stringItem, imageItem]
        let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(activityController, animated: true)
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
            combineString += "?amount=\(amount)"
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
