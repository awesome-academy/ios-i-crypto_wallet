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
    static var newTransaction: Transaction?
    private var assetHeader: AssetHeader?
    private var transactionList = [Transaction]()
    private var transactionDateList = [String]()
    private let transactionRepository: TransactionRepository = TransactionRepositoryImpl(api: APIService.share)
    private let assetRepository: AssetRepository = AssetRepositoryImpl(api: APIService.share)
    private var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadAllData()
    }
    
    private func configView() {
        assetHeader = AssetHeader(frame: CGRect(x: 0,
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
                if let assetInfo = self?.assetInfo {
                    sendTransactionController.assetInfo = assetInfo
                }
                self?.navigationController?.pushViewController(sendTransactionController, animated: true)
            }
            $0.receiveButtonTapped = { [weak self] in
                let receiveTransactionController = ReceiveTransactionViewController.instantiate().then {
                    guard let assetInfo = self?.assetInfo else {
                        return
                    }
                    $0.assetInfo = assetInfo
                }
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
    }
    
    private func reloadAllData() {
        fetchTransactionListAndLoadData()
        fetchAndReloadAssetInfo()
    }
    
    @objc private func handleAssetDetailTapped(_ sender: UIBarButtonItem) {
        let assetDetailController = AssetDetailViewController.instantiate()
        navigationController?.pushViewController(assetDetailController, animated: true)
    }
    
    private func getTransactionDateList(transactionList: [Transaction]) -> [String] {
        var transactionDateList = [String]()
        transactionList.forEach {
            guard let timeStamp = Double($0.timeStamp) else {
                return
            }
            let stringDate = Date.convertTimeStampToDate(timeStamp: timeStamp)
            if !transactionDateList.contains(stringDate) {
                transactionDateList.append(stringDate)
            }
        }
        return transactionDateList
    }
    
    private func fetchAndReloadAssetInfo() {
        guard var assetInfo = assetInfo else {
            return
        }
        if assetInfo.type == .coin {
            assetRepository.getEthereumInfo { [weak self] (result) in
                guard let self = self else {
                    return
                }
                switch result {
                case .success(let ethereumMarketResponse):
                    if let ethereumMarketResponse = ethereumMarketResponse {
                        assetInfo.price = ethereumMarketResponse.price
                        assetInfo.id = ethereumMarketResponse.id
                        assetInfo.websiteSlug = ethereumMarketResponse.websiteSlug
                        assetInfo.twentyFourHChange = ethereumMarketResponse.usdPercentChange
                        let group = DispatchGroup()
                        group.enter()
                        DispatchQueue.global(qos: .userInteractive).async {
                            if let address = Wallet.sharedWallet?.walletAddress,
                                let amount = EthereumInteraction.getEtherBalance(address: address),
                                let amountDouble = Double(amount) {
                                assetInfo.amount = amountDouble
                                group.leave()
                            } else {
                                group.leave()
                            }
                        }
                        group.notify(queue: .main, execute: {
                            self.assetInfo = assetInfo
                            if let assetHeader = self.assetHeader {
                                assetHeader.setAssetInfo(assetInfo)
                            }
                        })
                    }
                case .failure(let error):
                    self.showErrorAlert(message: error?.errorMessage)
                }
            }
        } else {
            assetRepository.getAssetMarket(contractAddress: assetInfo.smartContractAddress) { [weak self] (result) in
                guard let self = self else {
                    return
                }
                switch result {
                case .success(let assetMarketResponse):
                    if let assetMarket = assetMarketResponse?.assetMarket {
                        assetInfo.price = assetMarket.price
                        assetInfo.id = assetMarket.id
                        assetInfo.websiteSlug = assetMarket.websiteSlug
                        assetInfo.twentyFourHChange = assetMarket.percentChange24h
                        let group = DispatchGroup()
                        group.enter()
                        DispatchQueue.global(qos: .userInteractive).async {
                            if let address = Wallet.sharedWallet?.walletAddress,
                                let amount = EthereumInteraction.getERC20TokenBalance(
                                    contractAddress: assetInfo.smartContractAddress,
                                    walletAddress: address) {
                                assetInfo.amount = amount / pow(10, assetInfo.decimals)
                                group.leave()
                            } else {
                                group.leave()
                            }
                        }
                        group.notify(queue: .main, execute: {
                            self.assetInfo = assetInfo
                            if let assetHeader = self.assetHeader {
                                assetHeader.setAssetInfo(assetInfo)
                            }
                        })
                    }
                case .failure(let error):
                    self.showErrorAlert(message: error?.errorMessage)
                }
            }
        }
    }
    
    private func fetchTransactionListAndLoadData() {
        view.showOverlayIndicator()
        self.transactionList.removeAll()
        self.transactionDateList.removeAll()
        guard let assetInfo = assetInfo, let wallet = Wallet.sharedWallet else {
            return
        }
        if let newTransaction = AssetViewController.newTransaction {
            if newTransaction.to == assetInfo.smartContractAddress || assetInfo.type == .coin {
                self.transactionList.append(newTransaction)
            }
        }
        if assetInfo.type == .coin {
            transactionRepository.getTransactionList(walletAddress: wallet.walletAddress,
                                                     page: page) { [weak self] (result) in
                guard let self = self else {
                    return
                }
                switch result {
                case .success(let transactionResponse):
                    guard let transactionList = transactionResponse?.transactions else {
                        return
                    }
                    if let newTransaction = AssetViewController.newTransaction {
                        transactionList.forEach {
                            if $0.id == newTransaction.id {
                                AssetViewController.newTransaction = nil
                                self.transactionList.remove(at: 0)
                            }
                        }
                    }
                    self.transactionList += transactionList
                    self.transactionDateList = self.getTransactionDateList(transactionList: self.transactionList)
                    DispatchQueue.main.async {
                        self.transactionTableView.reloadData()
                    }
                case .failure(let error):
                    self.showErrorAlert(message: error?.errorMessage)
                }
                DispatchQueue.main.async {
                    self.view.hideOverlayIndicator()
                }
            }
        } else {
            transactionRepository.getTransactionList(walletAddress: wallet.walletAddress,
                                                     page: page,
                                                     contractAddress:
            assetInfo.smartContractAddress) { [weak self] (result) in
                guard let self = self else {
                    return
                }
                switch result {
                case .success(let transactionResponse):
                    guard let transactionList = transactionResponse?.transactions else {
                        return
                    }
                    self.transactionList += transactionList
                    self.transactionDateList = self.getTransactionDateList(transactionList: self.transactionList)
                    DispatchQueue.main.async {
                        self.transactionTableView.reloadData()
                    }
                case .failure(let error):
                    self.showErrorAlert(message: error?.errorMessage)
                }
                DispatchQueue.main.async {
                    self.view.hideOverlayIndicator()
                }
            }
        }
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
            let timestamp = Double($0.timeStamp) ?? 0
            return Date.convertTimeStampToDate(timeStamp: timestamp) == transactionDateList[section]
        }.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let transactionCell: TransactionCell = tableView.dequeueReusableCell(for: indexPath)
        var transactionType: TransactionType = .sent
        var address = ""
        var amount = 0.0
        var symbol = ""
        let sectionTransactionList = transactionList.filter {
            let timestamp = Double($0.timeStamp) ?? 0
            return Date.convertTimeStampToDate(timeStamp: timestamp) == transactionDateList[indexPath.section]
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
        if let newTransaction = AssetViewController.newTransaction, transaction.id == newTransaction.id {
            transactionType = .pending
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
        guard let assetInfo = assetInfo else {
            return
        }
        let transactionDetailController = TransactionDetailViewController.instantiate().then {
            let sectionTransactionList = transactionList.filter {
                let timestamp = Double($0.timeStamp) ?? 0
                return Date.convertTimeStampToDate(timeStamp: timestamp) == transactionDateList[indexPath.section]
            }
            let transaction = sectionTransactionList[indexPath.row]
            $0.transaction = transaction
            $0.assetInfo = assetInfo
        }
        navigationController?.pushViewController(transactionDetailController, animated: true)
    }
}
