//
//  ViewController.swift
//  AWS_Azure_Cognito
//
//  Created by Kseniia Zozulia on 7/17/18.
//  Copyright © 2018 Sezorus. All rights reserved.
//

import UIKit
import AWSCognitoAuth

class ViewController: UIViewController {
    @IBOutlet private weak var authenticationButton: UIButton!
    @IBOutlet private weak var userInfoTextView:     UITextView!
    
    private var authHelper: CognitoAuthHelper!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        authHelper = CognitoAuthHelper(delegate: self)
        setupAppearance()
        showUserInfo()
    }
    
    private func setupAppearance() {
        userInfoTextView.text = ""
        let authButtonTitle = authHelper.isSignedIn ? NSLocalizedString("Sign Out", comment: "") : NSLocalizedString("Sign In", comment: "")
        authenticationButton.setTitle(authButtonTitle, for: .normal)
    }
    
    private func login() {
        authHelper.getSesstion(delegate: self) { [weak self] (session, error) in
            guard let self = self else { return }
            
            if let error = error {
                self.showAlertWithTitle(nil, message: error.localizedDescription)
            }
       
            self.setupAppearance()
            self.showUserInfo()
        }
    }
    
    private func signOut() {
        authHelper.signOut { [ weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                self.showAlertWithTitle(nil, message: error.localizedDescription)
            }
            
            self.setupAppearance()
        }
    }
    
    private func showUserInfo() {
        guard let user = self.authHelper?.currentUser else { return }
        self.authHelper?.getUserInformation(user, completion: { [weak self] attributes in
            guard let self = self, let attributes = attributes else { return }
            
            var info: String = ""
            
            for attribute in attributes {
                guard let name = attribute.name, let value = attribute.value else { return }
                info.append(contentsOf: name)
                info.append(":\n\(value)\n\n")
            }
            
            DispatchQueue.main.async {
                self.userInfoTextView.text = info
            }
        })
    }
    
    @IBAction func authenticationAction(_ sender: Any) {
        if authHelper.isSignedIn {
            signOut()
        } else {
            login()
        }
    }
    
    private func showAlertWithTitle(_ title: String?, message: String) {
        DispatchQueue.main.async {
            let alert  = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            
            let action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) { (UIAlertAction) in
                alert.dismiss(animated: false, completion: nil)
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension ViewController: AWSCognitoAuthDelegate {
    func getViewController() -> UIViewController {
        return self
    }
}
