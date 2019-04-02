//
//  LoginViewController.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/1/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import UIKit
import Then

final class LoginViewController: UIViewController {
    @IBOutlet private weak var createWalletButton: UIButton!
    @IBOutlet private weak var recoverWalletButton: UIButton!
    @IBOutlet private weak var importGuideLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showNavigationBar()
    }
    
    @IBAction private func handleCreateWalletTapped(_ sender: Any) {
        let createWalletController = CreateWalletViewController.instantiate()
        navigationController?.pushViewController(createWalletController, animated: true)
    }
    
    @IBAction private func handleRecoverWalletTapped(_ sender: Any) {
        let recoverWalletController = RecoverWalletViewController.instantiate()
        navigationController?.pushViewController(recoverWalletController, animated: true)
    }
    
    @objc private func handleShowGuideTapped(_ sender: Any) {
        let importGuideController = GuideViewController.instantiate()
        navigationController?.pushViewController(importGuideController, animated: true)
    }
    
    private func configView() {
        [createWalletButton, recoverWalletButton].forEach {
            $0.setBorder(cornerRadius: 5, borderWidth: 2, borderColor: .darkGray)
        }
        let tapImportGuideLabel = UITapGestureRecognizer().then {
            $0.addTarget(self, action: #selector(handleShowGuideTapped(_:)))
        }
        importGuideLabel.do {
            $0.addGestureRecognizer(tapImportGuideLabel)
            $0.isUserInteractionEnabled = true
        }
    }
}
