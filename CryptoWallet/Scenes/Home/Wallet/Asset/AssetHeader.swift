//
//  AssetHeader.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/11/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import UIKit
import Reusable
import Toast_Swift

final class AssetHeader: UIView {
    @IBOutlet private weak var sendButton: UIButton!
    @IBOutlet private weak var receiveButton: UIButton!
    @IBOutlet private weak var assetLogoImageView: UIImageView!
    @IBOutlet private weak var assetAmountLabel: UILabel!
    @IBOutlet private weak var assetValueLabel: UILabel!
    @IBOutlet private weak var assetPriceLabel: UILabel!
    @IBOutlet private weak var usdPercentChange: UILabel!
    @IBOutlet private weak var receivingAddressLabel: UILabel!
    @IBOutlet private weak var addressView: UIView!
    @IBOutlet private weak var addressLabel: UILabel!
    
    var sendButtonTapped: (() -> Void)?
    var receiveButtonTapped: (() -> Void)?
    var makeToast: ((String) -> Void)?
    var assetInfo: AssetInfo?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configView()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        assetLogoImageView.setBorder(cornerRadius: assetLogoImageView.frame.width / 2,
                                     borderWidth: 1,
                                     borderColor: .darkGray)
    }
    
    private func configView() {
        loadNibContent()
        [sendButton, receiveButton].forEach {
            $0.setBorder(cornerRadius: 5, borderWidth: 0, borderColor: .white)
        }
        receivingAddressLabel.do {
            $0.bounds.origin = CGPoint(x: 20, y: -(receivingAddressLabel.frame.height / 2))
        }
        let headerLine = CALayer().then {
            $0.frame = CGRect(x: receivingAddressLabel.bounds.width + 30,
                              y: 0,
                              width: addressView.frame.width - receivingAddressLabel.bounds.width - 30,
                              height: 1)
            $0.backgroundColor = UIColor.lightGray.cgColor
        }
        let footerLine = CALayer().then {
            $0.frame = CGRect(x: 0, y: addressView.frame.height - 1, width: addressView.frame.width, height: 1)
            $0.backgroundColor = UIColor.lightGray.cgColor
        }
        addressView.do {
            $0.layer.addSublayer(headerLine)
            $0.layer.addSublayer(footerLine)
        }
    }
    
    func setAssetInfo(_ assetInfo: AssetInfo) {
        self.assetInfo = assetInfo
        assetAmountLabel.do {
            $0.text = String(format: "%.4f", assetInfo.amount) + String(assetInfo.symbol)
        }
        assetLogoImageView.do {
            if let logo = assetInfo.logo {
                $0.image = logo
            } else {
                if assetInfo.id == 0 {
                    $0.image = UIImage(named: "default-token-icon")
                } else {
                    let urlImage = URL(string: URLs.cmcCoinIconAPI + "/\(assetInfo.id).png")
                    $0.kf.setImage(with: urlImage)
                }
            }
            $0.contentMode = .scaleAspectFit
            $0.clipsToBounds = true
        }
        assetPriceLabel.do {
            $0.text = "$" + String(format: "%.2f", assetInfo.price)
        }
        usdPercentChange.do {
            $0.textColor = assetInfo.twentyFourHChange < 0 ? .red :
                assetInfo.twentyFourHChange == 0 ? .gray : UIColor.greenColor
            $0.text = assetInfo.twentyFourHChange <= 0 ?
                "\(assetInfo.twentyFourHChange)%" :
            "+\(assetInfo.twentyFourHChange)%"
        }
        assetValueLabel.do {
            $0.text = "$" +  String(format: "%.2f", assetInfo.amount * assetInfo.price)
        }
        addressLabel.do {
            if let address = Wallet.sharedWallet?.walletAddress {
                $0.text = address
            }
        }
    }
    
    @IBAction private func handleSendButtonTapped(_ sender: Any) {
        sendButtonTapped?()
    }
    
    @IBAction private func handleReceiveButtonTapped(_ sender: Any) {
        receiveButtonTapped?()
    }
    
    @IBAction private func handleCopyAddressTapped(_ sender: Any) {
        guard let address = Wallet.sharedWallet?.walletAddress else {
            return
        }
        UIPasteboard.general.string = address
        makeToast?("Address copied")
    }
}

extension AssetHeader: NibOwnerLoadable {
}
