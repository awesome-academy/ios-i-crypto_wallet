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
    @IBOutlet private weak var sixHoursChartLabel: UIButton!
    @IBOutlet private weak var oneDayChartLabel: UIButton!
    @IBOutlet private weak var oneWeekChartLabel: UIButton!
    @IBOutlet private weak var oneMonthChartLabel: UIButton!
    @IBOutlet private weak var oneYearChartLabel: UIButton!
    @IBOutlet private weak var allChartLabel: UIButton!
    @IBOutlet weak var assetPriceChartLabel: UILabel!
    
    private var assetList = [AssetInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    private func configView() {
        [oneDayChartLabel,
         oneWeekChartLabel,
         oneMonthChartLabel,
         oneYearChartLabel,
         allChartLabel].forEach {
            $0?.setTitleColor(.darkGray, for: .normal)
        }
        let chart = Chart(frame: assetValueView.bounds)
        chart.delegate = self
        let data = DataMock.chartValueData
        let series = ChartSeries(data: data)
        series.area = true
        let xLabels = ChartHelper.findLabels(data: data, axis: .X, numberLabel: 6)
        chart.xLabels = xLabels
        chart.xLabelsFormatter = { String(Int(round($1))) + "h" }
        let yLabels = ChartHelper.findLabels(data: data, axis: .Y, numberLabel: 6)
        chart.yLabels = yLabels
        chart.yLabelsFormatter = { "$" + String(Int($1)) }
        chart.add(series)
        chart.hideHighlightLineOnTouchEnd = true
        assetValueView.addSubview(chart)
        assetListTableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.rowHeight = 60
            $0.estimatedRowHeight = UITableView.automaticDimension
            $0.tableFooterView = UIView()
        }
        assetList.append(AssetInfo.mock())
    }
    
    @IBAction private func handleChartTimeTapped(_ sender: UIButton) {
        [sixHoursChartLabel,
         oneDayChartLabel,
         oneWeekChartLabel,
         oneMonthChartLabel,
         oneYearChartLabel,
         allChartLabel].forEach {
            $0?.setTitleColor(.darkGray, for: .normal)
        }
        sender.do {
            $0.setTitleColor(Colors.blueColor, for: .normal)
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
    }
}
