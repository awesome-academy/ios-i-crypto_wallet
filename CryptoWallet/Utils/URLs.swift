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
    static let transactionAPI = baseUrl + "/ethereum/transactions"
    static let tokenPriceAPI = baseUrl + "/prices"
    static let tokenInfoAPI = baseUrl + "/v2/tokens"
    static let assetMarketAPI = baseUrl + "/tickers"
}
