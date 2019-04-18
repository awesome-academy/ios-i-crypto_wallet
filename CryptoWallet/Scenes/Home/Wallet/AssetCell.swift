//
//  AssetCell.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/5/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import UIKit
import Reusable
import Kingfisher

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
        assetNameLabel.do {
            $0.text = assetInfo.name
        }
        assetPriceLabel.do {
            $0.text = "$" + assetInfo.price.threeDecimals()
        }
        asset24hChangeLabel.do {
            $0.textColor = assetInfo.twentyFourHChange < 0 ? .red :
                assetInfo.twentyFourHChange == 0 ? .gray : UIColor.greenColor
            $0.text = assetInfo.twentyFourHChange <= 0 ?
                "\(assetInfo.twentyFourHChange)%" :
                "+\(assetInfo.twentyFourHChange)%"
        }
        assetAmountLabel.do {
            $0.text = assetInfo.amount.threeDecimals(with: assetInfo.symbol)
        }
        assetValueLabel.do {
            $0.text = "$" +  (assetInfo.amount * assetInfo.price).twoDecimals()
        }
    }
}

extension AssetCell: Reusable {
}
