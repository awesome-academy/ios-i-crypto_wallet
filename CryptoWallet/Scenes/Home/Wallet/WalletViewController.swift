//
//  WalletViewController.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 3/29/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import UIKit
import SwiftChart

final class WalletViewController: UIViewController {
    @IBOutlet private weak var walletNameLabel: UILabel!
    @IBOutlet private weak var totalValueLabel: UILabel!
    @IBOutlet private weak var value24hChangeLabel: UILabel!
    @IBOutlet private weak var assetSearchBar: UISearchBar!
    @IBOutlet private weak var assetListTableView: UITableView!
    @IBOutlet private weak var assetValueView: UIView!
    @IBOutlet private weak var sixHoursChartButton: UIButton!
    @IBOutlet private weak var oneDayChartButton: UIButton!
    @IBOutlet private weak var oneWeekChartButton: UIButton!
    @IBOutlet private weak var oneMonthChartButton: UIButton!
    @IBOutlet private weak var oneYearChartButton: UIButton!
    @IBOutlet private weak var allChartButton: UIButton!
    @IBOutlet weak var assetPriceChartLabel: UILabel!
    
    private var assetList = [AssetInfo]()
    private var allAssetList = [AssetInfo()]
    private var chartData = [(x: Double, y: Double)]()
    private var chart: Chart?
    private let walletValueDataRepository: WalletValueDataRepository =
        WalletValueDataRepositoryImpl(api: APIService.share)
    private let assetRespository: AssetRepository = AssetRepositoryImpl(api: APIService.share)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showNavigationBar()
    }
    
    private func configView() {
        assetListTableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.rowHeight = 60
            $0.estimatedRowHeight = UITableView.automaticDimension
            $0.tableFooterView = UIView()
        }
        assetSearchBar.do {
            $0.delegate = self
        }
        walletNameLabel.do {
            $0.text = Wallet.sharedWallet?.walletName
        }
        handleChartTimeTapped(sixHoursChartButton)
        fetchAssetListAndLoadData()
    }
    
    @IBAction private func handleChartTimeTapped(_ sender: UIButton) {
        [sixHoursChartButton,
         oneDayChartButton,
         oneWeekChartButton,
         oneMonthChartButton,
         oneYearChartButton,
         allChartButton].forEach {
            $0?.setTitleColor(.darkGray, for: .normal)
        }
        sender.do {
            $0.setTitleColor(UIColor.blueColor, for: .normal)
        }
        guard let currentTitle = sender.currentTitle else {
            return
        }
        fetchDataAndDrawChart(currentChartType: currentTitle)
    }
    
    private func fetchDataAndDrawChart(currentChartType: String) {
        var fromTimestamp = 0.0
        var numberXPoint = 6
        switch currentChartType {
        case ChartType.sixHours.rawValue:
            if let pastTime = Calendar.current.date(byAdding: .hour, value: -6, to: Date()) {
                fromTimestamp = pastTime.timeIntervalSince1970
            }
            numberXPoint = 6
        case ChartType.oneDay.rawValue:
            if let pastTime = Calendar.current.date(byAdding: .day, value: -1, to: Date()) {
                fromTimestamp = pastTime.timeIntervalSince1970
            }
            numberXPoint = 6
        case ChartType.oneWeek.rawValue:
            if let pastTime = Calendar.current.date(byAdding: .day, value: -7, to: Date()) {
                fromTimestamp = pastTime.timeIntervalSince1970
            }
            numberXPoint = 6
        case ChartType.oneMonth.rawValue:
            if let pastTime = Calendar.current.date(byAdding: .month, value: -1, to: Date()) {
                fromTimestamp = pastTime.timeIntervalSince1970
            }
            numberXPoint = 6
        case ChartType.oneYear.rawValue:
            if let pastTime = Calendar.current.date(byAdding: .year, value: -1, to: Date()) {
                fromTimestamp = pastTime.timeIntervalSince1970
            }
            numberXPoint = 6
        case ChartType.allDay.rawValue:
            numberXPoint = 4
        default:
            if let pastTime = Calendar.current.date(byAdding: .hour, value: -6, to: Date()) {
                fromTimestamp = pastTime.timeIntervalSince1970
            }
        }
        guard let address = Wallet.sharedWallet?.walletAddress else {
            return
        }
        walletValueDataRepository.getWalletValueData(address: address,
                                                     from: fromTimestamp) { (result) in
            switch result {
            case .success(let walletValueDataResponse):
                guard let walletValueDataResponse = walletValueDataResponse else {
                    return
                }
                self.totalValueLabel.do {
                    $0.text = "$\(walletValueDataResponse.totalUsd)"
                }
                self.value24hChangeLabel.do {
                    $0.text = walletValueDataResponse.usdPercentChange > 0 ?
                        "+\(walletValueDataResponse.usdPercentChange)%" :
                        "\(walletValueDataResponse.usdPercentChange)%"
                    $0.textColor = walletValueDataResponse.usdPercentChange > 0 ?
                        .greenColor : .red
                }
                if let history = walletValueDataResponse.history {
                    self.chartData = ChartHelper.convertWalletValueToChartData(walletValues: history) ?? []
                }
                DispatchQueue.main.async {
                    self.drawChart(chartType: ChartType(rawValue: currentChartType) ?? .sixHours,
                                   chartData: self.chartData,
                                   numberXPoint: numberXPoint)
                }
            case .failure(let error):
                self.showErrorAlert(message: error?.errorMessage)
            }
        }
    }
    
    private func drawChart(chartType: ChartType, chartData: [(x: Double, y: Double)], numberXPoint: Int = 6) {
        if let chart = chart {
            chart.removeFromSuperview()
        }
        chart = Chart(frame: assetValueView.bounds)
        guard let chart = chart else {
            return
        }
        chart.delegate = self
        let series = ChartSeries(data: chartData)
        series.area = true
        let xLabels = ChartHelper.findLabels(data: chartData, axis: .X, numberPoint: numberXPoint)
        chart.xLabels = xLabels
        chart.xLabelsFormatter = {
            let date = Date(timeIntervalSince1970: $1)
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC+7")
            dateFormatter.locale = NSLocale.current
            switch chartType {
            case .sixHours, .oneDay:
                dateFormatter.dateFormat = "HH:mm"
            case .oneWeek, .oneMonth, .oneYear:
                dateFormatter.dateFormat = "MMM dd"
            case .allDay:
                dateFormatter.dateFormat = "MMM dd, yyyy"
            }
            return dateFormatter.string(from: date)
        }
        let yLabels = ChartHelper.findLabels(data: chartData, axis: .Y, numberPoint: 6)
        chart.yLabels = yLabels
        chart.yLabelsFormatter = { "$" + String(Int($1)) }
        chart.add(series)
        chart.hideHighlightLineOnTouchEnd = true
        assetValueView.addSubview(chart)
    }
    
    private func fetchAssetListAndLoadData() {
        guard let address = Wallet.sharedWallet?.walletAddress else {
            return
        }
        assetRespository.getAssetList(address: address) { (result) in
            switch result {
            case .success(let tokenListResponse):
                guard let tokenListResponse = tokenListResponse else {
                    return
                }
                self.allAssetList[0].amount = tokenListResponse.etherBalance
                self.assetRespository.getEthereumInfo { (result) in
                    switch result {
                    case .success(let ethereumMarketResponse):
                        if let fetchedEthereum = ethereumMarketResponse {
                            self.allAssetList[0].name = fetchedEthereum.name
                            self.allAssetList[0].logo = UIImage(named: "ethereum")
                            self.allAssetList[0].symbol = fetchedEthereum.symbol
                            self.allAssetList[0].price = fetchedEthereum.price
                            self.allAssetList[0].twentyFourHChange = fetchedEthereum.usdPercentChange
                            self.allAssetList[0].type = .coin
                            self.allAssetList[0].decimals = 18
                            DispatchQueue.main.async {
                                self.assetList = self.allAssetList
                                self.assetListTableView.reloadData()
                            }
                        }
                    case .failure(let error):
                        self.showErrorAlert(message: error?.errorMessage)
                    }
                }
                guard let tokenList = tokenListResponse.tokens, !tokenList.isEmpty else {
                    return
                }
                tokenList.forEach {
                    var assetInfo = AssetInfo()
                    assetInfo.name = $0.name
                    assetInfo.symbol = $0.symbol
                    assetInfo.decimals = $0.decimals
                    assetInfo.amount = $0.balance / pow(10.0, $0.decimals)
                    assetInfo.price = $0.price
                    assetInfo.twentyFourHChange = $0.usdPercentChange
                    assetInfo.smartContractAddress = $0.address
                    self.allAssetList.append(assetInfo)
                }
                self.assetRespository.getCMCCoinInfo(completion: { (result) in
                    switch result {
                    case .success(let cmcCoinInfoList):
                        for i in 0..<self.allAssetList.count {
                            let element = cmcCoinInfoList?.first(where: {
                                $0.symbol == self.allAssetList[i].symbol
                            })
                            if let matchedElement = element {
                                self.allAssetList[i].id = matchedElement.id
                            }
                        }
                        DispatchQueue.main.async {
                            self.assetList = self.allAssetList
                            self.assetListTableView.reloadData()
                        }
                    case .failure(let error):
                        self.showErrorAlert(message: error?.errorMessage)
                    }
                })
            case .failure(let error):
                self.showErrorAlert(message: error?.errorMessage)
            }
        }
    }
}

extension WalletViewController: ChartDelegate {
    func didTouchChart(_ chart: Chart, indexes: [Int?], x: Double, left: CGFloat) {
        for (seriesIndex, dataIndex) in indexes.enumerated() {
            if let dataIndex = dataIndex,
            let value = chart.valueForSeries(seriesIndex, atIndex: dataIndex),
            let superview = assetPriceChartLabel.superview {
                assetPriceChartLabel.do {
                    $0.isHidden = false
                    $0.text = String(value)
                    $0.frame = CGRect(x: left - ($0.frame.width / 2),
                                      y: 0,
                                      width: $0.frame.width,
                                      height: superview.frame.height)
                }
            }
        }
    }
    
    func didFinishTouchingChart(_ chart: Chart) {
    }
    
    func didEndTouchingChart(_ chart: Chart) {
        assetPriceChartLabel.do {
            $0.isHidden = true
        }
    }
}

extension WalletViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assetList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AssetCell = tableView.dequeueReusableCell(for: indexPath)
        cell.setCellValue(assetList[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let assetController = AssetViewController.instantiate()
        assetController.assetInfo = assetList[indexPath.row]
        navigationController?.pushViewController(assetController, animated: true)
    }
}

extension WalletViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            assetList = allAssetList
            self.assetListTableView.reloadData()
        } else {
            self.assetList = self.allAssetList.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
            self.assetListTableView.reloadData()
        }
    }
}
