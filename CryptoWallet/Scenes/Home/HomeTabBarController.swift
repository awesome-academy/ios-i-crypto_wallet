//
//  HomeTabBarController.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/3/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import UIKit
import Reusable

final class HomeTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension HomeTabBarController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
