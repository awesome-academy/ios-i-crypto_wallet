//
//  TransactionDetailViewController.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/16/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import UIKit
import Reusable
import BigInt
import Web3swift

final class TransactionDetailViewController: UIViewController {
    @IBOutlet private weak var transactionDetailTableView: UITableView!
    
    var transaction: Transaction?
    var assetInfo: AssetInfo?
    private var titleList = ["Recipient", "Transaction #", "Network Fee", "Confirmations", "Transaction Time", "Nonce"]
    private var contentList = Array(repeating: "---", count: 6)
    
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
        navigationItem.do {
            $0.title = "Transaction"
            $0.rightBarButtonItem = shareButton
        }
        transactionDetailTableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.rowHeight = 60
            $0.estimatedRowHeight = UITableView.automaticDimension
        }
        fetchAndLoadTransactionDetail()
    }
    
    private func fetchAndLoadTransactionDetail() {
        guard let transaction = transaction,
            let assetInfo = assetInfo,
            let wallet = Wallet.sharedWallet else {
            return
        }
        view.showOverlayIndicator()
        var transactionType: TransactionType = .sent
        var address = ""
        var amount = 0.0
        var symbol = ""
        if let contractOperation = transaction.contractOperation {
            if assetInfo.type == .coin {
                transactionType = .smartContractCall
                address = transaction.to
                symbol = "ETH"
            } else {
                if contractOperation.from.lowercased() == wallet.walletAddress.lowercased() {
                    transactionType = .transferTokenTo(token: assetInfo.symbol)
                    address = contractOperation.to
                } else {
                    transactionType = .transferTokenFrom(token: assetInfo.symbol)
                    address = contractOperation.from
                }
                if let value = Double(contractOperation.value) {
                    if let decimals = transaction.contractOperation?.contractTransaction?.decimals {
                        amount = value / pow(10, Double(decimals))
                    }
                }
                symbol = assetInfo.symbol
            }
        } else {
            if transaction.from.lowercased() == wallet.walletAddress.lowercased() {
                transactionType = .sent
                address = transaction.to
            } else {
                transactionType = .received
                address = transaction.from
            }
            if let value = Double(transaction.value) {
                amount = value / pow(10, 18)
            }
            symbol = "ETH"
        }
        if let newTransaction = AssetViewController.newTransaction,
            transaction.id == newTransaction.id {
            transactionType = .pending
        }
        let transactionDetailHeader = TransactionDetailHeader(frame:
            CGRect(x: 0,
                   y: 0,
                   width: transactionDetailTableView.frame.size.width,
                   height: transactionDetailTableView.frame.size.height / 5)).then {
                    $0.setHeaderInfo(transactionType: transactionType,
                                     symbol: symbol,
                                     amount: amount,
                                     value: amount * assetInfo.price)
        }
        let moreDetailButton = UIButton(type: .system).then {
            $0.frame.size = CGSize(width: transactionDetailTableView.frame.size.width - 40, height: 40)
            $0.setTitle("More Details", for: .normal)
            $0.setBorder(cornerRadius: 5, borderWidth: 1, borderColor: .blueColor)
            $0.addTarget(self, action: #selector(handleMoreDetailButtonTapped(_:)), for: .touchDown)
        }
        transactionDetailTableView.tableHeaderView = transactionDetailHeader
        let transactionDetailFooter = UIView(frame:
            CGRect(x: 0,
                   y: 0,
                   width: transactionDetailTableView.frame.size.width,
                   height: transactionDetailTableView.frame.size.height / 10)).then {
                    moreDetailButton.center = $0.center
                    $0.addSubview(moreDetailButton)
        }
        transactionDetailTableView.tableFooterView = transactionDetailFooter
        switch transactionType {
        case .received, .transferTokenFrom(token: _):
            titleList[0] = "Sender"
        case .sent, .transferTokenTo(token: _), .pending, .smartContractCall:
            titleList[0] = "Recipient"
        }
        contentList[0] = address
        let firstTransactionIdChars = transaction.id.prefix(20)
        let lastTransactionIdChars = transaction.id.suffix(20)
        contentList[1] = firstTransactionIdChars + "..." + lastTransactionIdChars
        if let gasPrice = Double(transaction.gasPrice),
            let gasLimitUsed = Double(transaction.gasUsed),
            let networkFee = Web3.Utils.formatToEthereumUnits(BigInt(gasPrice * gasLimitUsed),
                                                              toUnits: .eth,
                                                              decimals: 6),
            let fee = Double(networkFee) {
            contentList[2] = networkFee + " ETH ($" + (fee * assetInfo.price).twoDecimals() + ")"
        }
        if let timeStamp = Double(transaction.timeStamp) {
            let date = Date(timeIntervalSince1970: timeStamp)
            contentList[4] = Date.convertDateToString(date: date, format: "MMM dd, yyyy h:mm:ss a")
        }
        contentList[5] = String(transaction.nonce).isEmpty ?  contentList[5] : String(transaction.nonce)
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                guard let currentBlockNumber = try EthereumInteraction.getBlockNumber(),
                    let blockNumber = (try EthereumInteraction.getTransactionByHash(txHash: transaction.id))?.blockNumber else {
                    return
                }
                let confirmations = currentBlockNumber - blockNumber
                self.contentList[3] = String(confirmations)
                DispatchQueue.main.async {
                    self.transactionDetailTableView.reloadData()
                    self.view.hideOverlayIndicator()
                }
            } catch {
                DispatchQueue.main.async {
                    self.view.hideOverlayIndicator()
                }
                self.showErrorAlert(message: error.localizedDescription)
            }
        }
    }
    
    @objc private func handleMoreDetailButtonTapped(_ sender: Any) {
        guard let transaction = transaction else {
            return
        }
        let webViewController = WebViewController.instantiate().then {
            $0.titleString = "Etherscan"
            $0.urlString = URLs.etherScanTransaction + "/" + transaction.id
        }
        navigationController?.pushViewController(webViewController, animated: true)
    }
    
    @objc private func handleShareButtonTapped(_ sender: Any) {
        guard let transaction = transaction else {
            return
        }
        let stringItem = URLs.etherScanTransaction + "/" + transaction.id
        let items: [Any] = [stringItem]
        let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(activityController, animated: true)
    }
}

extension TransactionDetailViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.wallet
}

extension TransactionDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let transactionDetailCell: TransactionDetailCell = tableView.dequeueReusableCell(for: indexPath)
        transactionDetailCell.setCellValue(title: titleList[indexPath.row],
                                           description: contentList[indexPath.row])
        return transactionDetailCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
