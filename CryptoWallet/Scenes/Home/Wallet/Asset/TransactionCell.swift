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
        transactionTypeLabel.do {
            $0.text = transactionType.toString()
        }
        addressLabel.do {
            let firstEightCharacters = address.prefix(10)
            let lastEightCharacters = address.suffix(10)
            var inboxType = ""
            switch transactionType {
            case .received, .transferTokenFrom(token: _):
                inboxType = "From"
            case .sent, .transferTokenTo(token: _), .pending, .smartContractCall:
                inboxType = "To"
            }
            $0.text = inboxType + ": " + String(firstEightCharacters) + "..." + String(lastEightCharacters)
        }
        amountLabel.do {
            switch transactionType {
            case .received, .transferTokenFrom(token: _):
                $0.textColor = .greenColor
                $0.text = "+" + String(format: "%.3f", amount) + " " + symbol
            case .sent, .pending, .transferTokenTo(token: _):
                $0.text = "-" + String(format: "%.3f", amount) + " " + symbol
                $0.textColor = .darkGray
            default:
                $0.text = String(format: "%.3f", amount) + " " + symbol
                $0.textColor = .darkGray
            }
        }
    }
}
