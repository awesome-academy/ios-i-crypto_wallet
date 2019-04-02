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
    var wallet: Wallet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    private func configView() {
        let backupLaterBarButton = UIBarButtonItem(title: "Backup later",
                                                   style: .done,
                                                   target: self,
                                                   action: #selector(handleBackupLaterTapped(_:)))
        navigationItem.rightBarButtonItem = backupLaterBarButton
    }
    
    @objc private func handleBackupLaterTapped(_ sender: Any) {
    }
}

extension BackupNoticeViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
