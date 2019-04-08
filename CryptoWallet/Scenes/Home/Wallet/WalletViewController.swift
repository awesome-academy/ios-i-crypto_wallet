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
    private var allAssetList = [AssetInfo]()
    private var chartData = [(x: Double, y: Double)]()
    private var chart: Chart?
    
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
        allAssetList.append(AssetInfo.mock())
        assetList = allAssetList
        assetSearchBar.do {
            $0.delegate = self
        }
        walletNameLabel.do {
            $0.text = Wallet.sharedWallet?.walletName
        }
        handleChartTimeTapped(sixHoursChartButton)
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
        guard let currentTitle = sender.currentTitle  else {
            return
        }
        if currentTitle == ChartType.allDay.rawValue {
            drawChart(chartType: .allDay, chartData: DataMock.chartValueData, numberXPoint: 4)
        } else {
            drawChart(chartType: ChartType(rawValue: currentTitle) ?? .sixHours, chartData: DataMock.chartValueData)
        }
    }
    
    private func drawChart(chartType: ChartType, chartData: [(x: Double, y: Double)], numberXPoint: Int = 6) {
        guard var chart = chart else {
            return
        }
        chart.removeFromSuperview()
        chart = Chart(frame: assetValueView.bounds)
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
            case .oneWeek:
                dateFormatter.dateFormat = "dd"
            case .oneMonth, .oneYear:
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
