//
//  TransactionCell.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/11/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import UIKit
import Reusable

final class TransactionCell: UITableViewCell, Reusable {
    @IBOutlet private weak var transactionTypeImage: UIImageView!
    @IBOutlet private weak var transactionTypeLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        transactionTypeImage.setBorder(cornerRadius: transactionTypeImage.frame.width / 2,
                                       borderWidth: 1,
                                       borderColor: .darkGray)
    }
    
    func setCellValue(transactionType: TransactionType, address: String, amount: Double, symbol: String) {
        transactionTypeImage.do {
            switch transactionType {
            case .pending:
                $0.image = UIImage(named: "pending-icon")
            case .received, .transferTokenFrom(token: _):
                $0.image = UIImage(named: "received-icon")
            case .sent, .transferTokenTo(token: _):
                $0.image = UIImage(named: "sent-icon")
            case .smartContractCall:
                $0.image = UIImage(named: "contract-icon")
            }
            $0.contentMode = .center
        }
        switch transactionType {
        case .pending:
            self.contentView.do {
                $0.backgroundColor = .yellowPendingColor
            }
        default:
            self.contentView.do {
                $0.backgroundColor = .white
            }
        }
        transactionTypeLabel.do {
            $0.text = transactionType.toString()
        }
        addressLabel.do {
            let firstCharacters = address.prefix(10)
            let lastCharacters = address.suffix(10)
            var inboxType = ""
            switch transactionType {
            case .received, .transferTokenFrom(token: _):
                inboxType = "From"
            case .sent, .transferTokenTo(token: _), .pending, .smartContractCall:
                inboxType = "To"
            }
            $0.text = inboxType + ": " + String(firstCharacters) + "..." + String(lastCharacters)
        }
        amountLabel.do {
            switch transactionType {
            case .received, .transferTokenFrom(token: _):
                $0.textColor = .greenColor
                $0.text = "+" + amount.threeDecimals(with: symbol)
            case .sent, .pending, .transferTokenTo(token: _):
                $0.text = "-" + amount.threeDecimals(with: symbol)
                $0.textColor = .darkGray
            default:
                $0.text = amount.threeDecimals(with: symbol)
                $0.textColor = .darkGray
            }
        }
    }
}
