//
//  URLs.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 3/29/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import Foundation

enum URLs {
    static let baseTrustUrl = "https://api.trustwallet.com"
    static let baseCronJobUrl = "http://68.183.235.73:3012/api/app"
    static let cmcGraphAPI = "https://graphs2.coinmarketcap.com/currencies"
    static let cmcCoinIconAPI = "https://s2.coinmarketcap.com/static/img/coins/64x64"
    static let cmcCoinInfoData = "https://s2.coinmarketcap.com/generated/search/quick_search.json"
    static let cronJobAPI = baseCronJobUrl + "/create_event/v1"
    static let checkCronJobAPI = baseCronJobUrl + "/get_event/v1"
    static let totalValueChartAPI = "http://secretcat.spdns.org/wallet-tracker.php"
    static let transactionAPI = baseTrustUrl + "/ethereum/transactions"
    static let assetMarketAPI = baseTrustUrl + "/tickers"
    static let assetListAPI = "http://api.ethplorer.io/getAddressInfo"
}
