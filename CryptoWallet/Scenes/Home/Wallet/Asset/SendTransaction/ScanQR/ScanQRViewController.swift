//
//  ScanQRViewController.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/16/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import UIKit
import Reusable

final class ScanQRViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ScanQRViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.wallet
}
