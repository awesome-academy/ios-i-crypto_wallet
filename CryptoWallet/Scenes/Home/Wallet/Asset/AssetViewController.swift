//
//  AssetViewController.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/8/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import UIKit
import Reusable

final class AssetViewController: UIViewController {
    @IBOutlet private weak var transactionTableView: UITableView!
    
    var assetInfo: AssetInfo?
    var transactionList = [Transaction]()
    var transactionDateList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    private func configView() {
        let assetHeader = AssetHeader(frame: CGRect(x: 0,
                                                    y: 0,
                                                    width: transactionTableView.frame.width,
                                                    height: transactionTableView.frame.height / 2)).then {
            if let assetInfo = assetInfo {
                $0.setAssetInfo(assetInfo)
            }
            $0.makeToast = { [weak self] (message) in
                self?.view.makeToast(message)
            }
            $0.sendButtonTapped = { [weak self] in
                let sendTransactionController = SendTransactionViewController.instantiate()
                self?.navigationController?.pushViewController(sendTransactionController, animated: true)
            }
            $0.receiveButtonTapped = { [weak self] in
                let receiveTransactionController = ReceiveTransactionViewController.instantiate()
                self?.navigationController?.pushViewController(receiveTransactionController, animated: true)
            }
        }
        transactionTableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.tableHeaderView = assetHeader
            $0.tableFooterView = UIView()
            $0.rowHeight = 60
            $0.estimatedRowHeight = UITableView.automaticDimension
        }
        navigationController?.navigationBar.do {
            $0.barTintColor = .blueColor
            $0.tintColor = .white
            $0.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        }
        let detailAssetButton = UIBarButtonItem(image: UIImage(named: "chart-icon"),
                                                style: .done,
                                                target: self,
                                                action: #selector(handleAssetDetailTapped(_:)))
        navigationItem.do {
            guard let assetInfo = assetInfo else {
                return
            }
            $0.title = assetInfo.name + "(\(assetInfo.symbol))"
            $0.rightBarButtonItem = detailAssetButton
            $0.backBarButtonItem = UIBarButtonItem(title: "Back",
                                                   style: .plain,
                                                   target: nil,
                                                   action: nil)
        }
        transactionList = Transaction.mock() ?? []
        transactionDateList = getTransactionDateList(transactionList: transactionList)
        transactionTableView.reloadData()
    }
    
    @objc private func handleAssetDetailTapped(_ sender: UIBarButtonItem) {
        let assetDetailController = AssetDetailViewController.instantiate()
        navigationController?.pushViewController(assetDetailController, animated: true)
    }
    
    private func getTransactionDateList(transactionList: [Transaction]) -> [String] {
        var transactionDateList = [String]()
        transactionList.forEach {
            let stringDate = Date.convertTimeStampToDate(timeStamp: $0.timeStamp)
            if !transactionDateList.contains(stringDate) {
                transactionDateList.append(stringDate)
            }
        }
        return transactionDateList
    }
}

extension AssetViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.wallet
}

extension AssetViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return transactionDateList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionList.filter {
            return Date.convertTimeStampToDate(timeStamp: $0.timeStamp) == transactionDateList[section]
        }.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let transactionCell: TransactionCell = tableView.dequeueReusableCell(for: indexPath)
        var transactionType: TransactionType = .sent
        var address = ""
        var amount = 0.0
        var symbol = ""
        let sectionTransactionList = transactionList.filter {
            return Date.convertTimeStampToDate(timeStamp: $0.timeStamp) == transactionDateList[indexPath.section]
        }
        let transaction = sectionTransactionList[indexPath.row]
        guard let wallet = Wallet.sharedWallet, let assetInfo = assetInfo else {
            return UITableViewCell()
        }
        if let contractOperation = transaction.contractOperation {
            if assetInfo.type == .coin {
                transactionType = .smartContractCall
                address = transaction.to
                symbol = "ETH"
            } else {
                if contractOperation.from == wallet.walletAddress {
                    transactionType = .transferTokenTo(token: assetInfo.symbol)
                    address = contractOperation.to
                } else {
                    transactionType = .transferTokenFrom(token: assetInfo.symbol)
                    address = contractOperation.from
                }
                if let value = Double(contractOperation.value) {
                    amount = value
                }
                symbol = assetInfo.symbol
            }
        } else {
            if transaction.from == wallet.walletAddress {
                transactionType = .sent
                address = transaction.to
            } else {
                transactionType = .received
                address = transaction.from
            }
            amount = transaction.value
            symbol = "ETH"
        }
        transactionCell.setCellValue(transactionType: transactionType, address: address, amount: amount, symbol: symbol)
        return transactionCell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let today = Date.convertDateToString(date: Date())
        var yesterday = today
        if let yesterdayDate = Calendar.current.date(byAdding: .day, value: -1, to: Date()) {
            yesterday = Date.convertDateToString(date: yesterdayDate)
        }
        if transactionDateList[section] == today {
            return "Today"
        } else if transactionDateList[section] == yesterday, today != yesterday {
            return "Yesterday"
        } else {
            return transactionDateList[section]
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let transactionDetailController = TransactionDetailViewController.instantiate()
        navigationController?.pushViewController(transactionDetailController, animated: true)
    }
}

