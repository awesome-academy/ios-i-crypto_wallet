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
    var assetInfo: AssetInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension AssetViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.wallet
}

