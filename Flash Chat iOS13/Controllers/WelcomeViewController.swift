//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Jhojan Sobrino on 3/11/23.
//  Copyright © 2023 Angela Yu. All rights reserved.
//


import UIKit
import LocalAuthentication

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(WelcomeViewController.authenticationCompletionHandler(loginStatusNotification:)), name: .MTBiometricAuthenticationNotificationLoginStatus, object: nil)
        
        titleLabel.text=""
        var charIndex = 0.0
        let titleText = "OnlyChat"
        
        for letter in titleText{
       
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false){
                (timer) in self.titleLabel.text?.append(letter)
            }
            charIndex += 1
        }
        
    }
    
    let ChatViewController = "ChatViewController"

    
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
    
    func authenticateWithBiometric() {
        let bioAuth = FaceIdAuth()
        bioAuth.reasonString = "To login into the app"
        bioAuth.authenticationWithBiometricID()
    }
    
    func onLoginSuccess() {
        let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        let homeVC = mainStoryboard.instantiateViewController(withIdentifier: ChatViewController)
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
    
    func onLoginFail() {
        let alert = UIAlertController(title: "Login", message: "Login Failed", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
