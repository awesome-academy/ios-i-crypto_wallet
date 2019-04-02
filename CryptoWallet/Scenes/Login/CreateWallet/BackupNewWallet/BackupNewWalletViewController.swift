//
//  BackupNewWalletViewController.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/3/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import UIKit
import Reusable

final class BackupNewWalletViewController: UIViewController {
    @IBOutlet weak var mnenomicLabel: UILabel!
    
    var mnenomics = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    @IBAction func handleDoneTapped(_ sender: Any) {
        let homeTabBarController = HomeTabBarController.instantiate()
        present(homeTabBarController, animated: true, completion: nil)
    }
    
    private func configView() {
        mnenomicLabel.text = mnenomics
    }
}

extension BackupNewWalletViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
