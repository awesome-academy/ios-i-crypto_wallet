//
//  RecoverWalletViewController.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/2/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import UIKit
import Reusable
import Then

final class RecoverWalletViewController: UIViewController {
    @IBOutlet private weak var recoverDataTextView: UITextView!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var repeatPasswordTextField: UITextField!
    @IBOutlet private weak var recoverWalletButton: UIButton!
    @IBOutlet private weak var guideButton: UIButton!
    @IBOutlet private weak var recoverWalletNoticeLabel: UILabel!
    
    private var recoverDataPlaceHolder = "Mnenomic Phrase"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    @IBAction private func handleRecoverWalletTapped(_ sender: Any) {
    }
    
    @IBAction private func handleGuideTapped(_ sender: Any) {
    }
    
    @IBAction func handleRecoverMethodTabChanged(_ sender: UISegmentedControl) {
        let methodName = sender.titleForSegment(at: sender.selectedSegmentIndex) ?? "Mnenomic Phrase"
        recoverWalletNoticeLabel.text = "You can reset the password while importing the \(methodName)."
        recoverDataPlaceHolder = methodName
        if recoverDataTextView.textColor == .lightGray {
            recoverDataTextView.text = methodName
        }
    }
    
    private func configView() {
        recoverDataTextView.setBorder(cornerRadius: 5, borderWidth: 1, borderColor: .lightGray)
        recoverWalletButton.setBorder(cornerRadius: 5, borderWidth: 0, borderColor: .white)
        let headerLine = CALayer().then {
            $0.frame = CGRect(x: 0, y: 0, width: guideButton.frame.width, height: 1)
            $0.backgroundColor = UIColor.lightGray.cgColor
        }
        guideButton.do {
            $0.tintColor = UIColor(red: 0.00, green: 0.53, blue: 1.00, alpha: 1.0)
            $0.layer.addSublayer(headerLine)
            $0.setImage(UIImage(named: "book-icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.contentMode = .scaleAspectFit
        }
        [passwordTextField, repeatPasswordTextField].forEach {
            $0.underlined(height: 1, color: .lightGray)
        }
        recoverDataTextView.do {
            $0.delegate = self
            $0.textColor = .lightGray
            $0.text = recoverDataPlaceHolder
        }
    }
}

extension RecoverWalletViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}

extension RecoverWalletViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.do {
                $0.text = nil
                $0.textColor = .black
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = recoverDataPlaceHolder
            textView.textColor = .lightGray
        }
    }
}
