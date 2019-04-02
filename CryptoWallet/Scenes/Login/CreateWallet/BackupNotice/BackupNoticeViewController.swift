//
//  BackupNoticeViewController.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/2/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import UIKit
import Reusable

final class BackupNoticeViewController: UIViewController {
    internal var wallet: Wallet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension BackupNoticeViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
