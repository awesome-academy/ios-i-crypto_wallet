//
//  AssetCell.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/5/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import UIKit
import Reusable

final class AssetCell: UITableViewCell {
    @IBOutlet private weak var assetLogoImageView: UIImageView!
    @IBOutlet private weak var assetNameLabel: UILabel!
    @IBOutlet private weak var assetPriceLabel: UILabel!
    @IBOutlet private weak var asset24hChangeLabel: UILabel!
    @IBOutlet private weak var assetAmountLabel: UILabel!
    @IBOutlet private weak var assetValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        assetLogoImageView.setBorder(cornerRadius: assetLogoImageView.frame.width / 2,
                                     borderWidth: 1,
                                     borderColor: .lightGray)
    }
    
    func setCellValue(_ assetInfo: AssetInfo) {
        assetLogoImageView.do {
            $0.image = assetInfo.logo
            $0.contentMode = .scaleAspectFit
            $0.clipsToBounds = true
        }
        assetNameLabel.do {
            $0.text = assetInfo.name
        }
        assetPriceLabel.do {
            $0.text = "$\(assetInfo.price)"
        }
        asset24hChangeLabel.do {
            $0.textColor = assetInfo.twentyFourHChange < 0 ? .red : UIColor.greenColor
            $0.text = "\(assetInfo.twentyFourHChange)%"
        }
        assetAmountLabel.do {
            $0.text = "\(assetInfo.amount) \(assetInfo.symbol)"
        }
        assetValueLabel.do {
            $0.text = "$" +  String(format: "%.2f", assetInfo.amount * assetInfo.price)
        }
    }
}

extension AssetCell: Reusable {
}
