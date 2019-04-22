//
//  TransactionDetailHeader.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/19/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import UIKit
import Reusable

final class TransactionDetailHeader: UIView, NibOwnerLoadable {
    @IBOutlet private weak var transactionTypeImage: UIImageView!
    @IBOutlet private weak var amountLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!
    
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
        transactionTypeImage.do {
            $0.setBorder(cornerRadius: $0.frame.width / 2, borderWidth: 1, borderColor: .lightGray)
            $0.contentMode = .center
        }
    }
    
    private func configView() {
        loadNibContent()
        let footerLine = CALayer().then {
            $0.frame = CGRect(x: 0, y: frame.size.height - 1, width: frame.size.width, height: 1)
            $0.backgroundColor = UIColor.lightGray.cgColor
        }
        layer.addSublayer(footerLine)
    }
    
    func setHeaderInfo(transactionType: TransactionType, symbol: String, amount: Double, value: Double) {
        switch transactionType {
        case .pending:
            transactionTypeImage.do {
                $0.image = UIImage(named: "pending-icon")
            }
            amountLabel.do {
                $0.text = (amount > 0 ? "-" : "") + amount.threeDecimals(with: symbol)
                $0.textColor = .black
            }
        case .sent, .smartContractCall, .transferTokenTo(token: _):
            transactionTypeImage.do {
                $0.image = UIImage(named: "sent-icon")
            }
            amountLabel.do {
                $0.text = (amount > 0 ? "-" : "") + amount.threeDecimals(with: symbol)
                $0.textColor = .black
            }
        case .received, .transferTokenFrom(token: _):
            transactionTypeImage.do {
                $0.image = UIImage(named: "received-icon")
            }
            amountLabel.do {
                $0.text = (amount > 0 ? "+" : "") + amount.threeDecimals(with: symbol)
                $0.textColor = .greenColor
            }
        }
        valueLabel.do {
            $0.text = "($" + value.twoDecimals() + ")"
        }
    }
}
