//
//  HomeTabBarController.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/3/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import UIKit
import Reusable
import Web3swift

final class HomeTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
//        DispatchQueue.global(qos: .userInteractive).async {
//            do {
//            let test = try EthereumInteraction.sendERC20Token(
//                smartContract: "0x7295bb8709ec1c22b758a8119a4214ffed016323",
//                toAddress: "0x1EF5B7C7d91adA52a5F4E32085F4adFAD5Ec3F6a",
//                value: 100,
//                gasPrice: 10_000_000_000,
//                gasLimit: 50_000,
//                password: "Abcd1234@")
//                let test = try EthereumInteraction.sendEther(
//                    toAddress: "0x1EF5B7C7d91adA52a5F4E32085F4adFAD5Ec3F6a",
//                    value: 1,
//                    gasPrice: 10_000_000_000,
//                    gasLimit: 21_000,
//                    password: "Abcd1234@")
//                if let test = test {
//                    print("----------------------------" + test.hash)
//                }
//            } catch Web3Error.inputError(let error) {
//                print("-----------------------------" + error)
//            } catch Web3Error.processingError(let error) {
//                print("-----------------------------" + error)
//            } catch {
//                print("----------------------------" + error.localizedDescription)
//            }
//        }
    }
}

extension HomeTabBarController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
