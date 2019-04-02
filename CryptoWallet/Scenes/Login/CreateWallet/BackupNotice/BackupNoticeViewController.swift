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
    var mnonemics = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    @IBAction private func handleBackupMnenomicTapped(_ sender: Any) {
        let backupNewWalletController = BackupNewWalletViewController.instantiate()
        navigationController?.pushViewController(backupNewWalletController, animated: true)
    }

    private func configView() {
        let backupLaterBarButton = UIBarButtonItem(title: "Backup later",
                                                   style: .done,
                                                   target: self,
                                                   action: #selector(handleBackupLaterTapped(_:)))
        navigationItem.rightBarButtonItem = backupLaterBarButton
    }
    
    @objc private func handleBackupLaterTapped(_ sender: Any) {
        let homeTabBarController = HomeTabBarController.instantiate()
        present(homeTabBarController, animated: true, completion: nil)
    }
}

extension BackupNoticeViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
