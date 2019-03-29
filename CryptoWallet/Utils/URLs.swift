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
    static let cmcAPIUrl = "https://graphs2.coinmarketcap.com/currencies"
    static let transactionAPI = baseUrl + "/ethereum/transactions"
    static let tokenPriceAPI = baseUrl + "/prices"
    static let tokenInfoAPI = baseUrl + "/v2/tokens"
    static let assetMarketAPI = baseUrl + "/tickers"
}
