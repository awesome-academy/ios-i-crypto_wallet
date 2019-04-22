//
//  TransactionDetailCell.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/19/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import UIKit
import Reusable

final class TransactionDetailCell: UITableViewCell, Reusable {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setCellValue(title: String, description: String) {
        titleLabel.do {
            $0.text = title
        }
        descriptionLabel.do {
            $0.text = description
        }
    }
}
