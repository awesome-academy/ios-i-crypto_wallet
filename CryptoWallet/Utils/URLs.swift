//
//  URLs.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 3/29/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import Foundation

enum URLs {
    static let baseUrl = "https://api.trustwallet.com"
    static let cmcGraphAPI = "https://graphs2.coinmarketcap.com/currencies"
    static let cmcCoinIconAPI = "https://s2.coinmarketcap.com/static/img/coins/64x64"
    static let cmcCoinInfoData = "https://s2.coinmarketcap.com/generated/search/quick_search.json"
    static let runCloudCronJobsAPI = "https://manage.runcloud.io/base-api/servers/\(RunCloud.serverId)/cronjobs"
    static let totalValueChartAPI = "http://secretcat.spdns.org/wallet-tracker.php"
    static let transactionAPI = baseUrl + "/ethereum/transactions"
    static let assetMarketAPI = baseUrl + "/tickers"
    static let assetListAPI = "http://api.ethplorer.io/getAddressInfo"
}
