//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Jhojan Sobrino on 3/11/23.
//  Copyright © 2023 Angela Yu. All rights reserved.
//


import UIKit
import LocalAuthentication
import CLTypingLabel

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: CLTypingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(WelcomeViewController.authenticationCompletionHandler(loginStatusNotification:)), name: .MTBiometricAuthenticationNotificationLoginStatus, object: nil)
        
        titleLabel.text="OnlyChat"
      
        
    }
    

    
     @objc func authenticationCompletionHandler(loginStatusNotification: Notification) {
        if let _ = loginStatusNotification.object as? FaceIdAuth, let userInfo = loginStatusNotification.userInfo {
            if let authStatus = userInfo[FaceIdAuth.status] as? FaceIdAuthStatus {
                if authStatus.success {
                    print("Login Success")
                    DispatchQueue.main.async {
                        self.onLoginSuccess()
                    }
                } else {
                    if let errorCode = authStatus.errorCode {
                        print("Login Fail with code \(String(describing: errorCode)) reason \(authStatus.errorMessage)")
                        DispatchQueue.main.async {
                            self.onLoginFail()
                            }
                    
                    }
                }
            }
        }
    }
    
    @IBAction func Biometric(_ sender: Any) {
        authenticateWithBiometric()
    }
    
    public func authenticateWithBiometric() {
        let bioAuth = FaceIdAuth()
        bioAuth.reasonString = "To login into the app"
        bioAuth.authenticationWithBiometricID()
    }
    
    func onLoginSuccess() {
        let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        let homeVC = mainStoryboard.instantiateViewController(withIdentifier: Constants.ChatViewController)
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
    
    func onLoginFail() {
        let alert = UIAlertController(title: "Login", message: "Login Failed", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
