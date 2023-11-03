//
//  FaceIdAuth.swift
//  Flash Chat iOS13
//
//  Created by Jhojan Sobrino on 3/11/23.
//  Copyright © 2023 Angela Yu. All rights reserved.
//
import Foundation
import LocalAuthentication

extension Notification.Name {
    static let MTBiometricAuthenticationNotificationLoginStatus = Notification.Name("LoginStatus")
}

struct FaceIdAuthStatus {
    var success = false
    var errorCode: Int?
    var errorMessage = ""
    
    mutating func setLoginSuccess() {
        self.success = true
    }
    
    mutating func setLoginFail(errorCode: Int, errorMessage: String) {
        self.success = false
        self.errorCode = errorCode
        self.errorMessage = errorMessage
    }
}

class FaceIdAuth {
    
    var authStatus =  FaceIdAuthStatus()
    //reasonString is prompted to user for login with touchid
    var reasonString = "For bio auth"
    static let status = "status"
    
    func authenticationWithBiometricID() {
        let localAuthenticationContext = LAContext()
        localAuthenticationContext.localizedFallbackTitle = "Use Passcode"
        
        var authError: NSError?
        
        if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            
            localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString) { success, error in
                
                if success {
                    self.authStatus.setLoginSuccess()
                    self.postNotification(userInfo: [FaceIdAuth.status : self.authStatus])
                    
                } else {
                    guard let error = error else {
                        return
                    }
                    let errorMessage = self.errorMessageForFails(errorCode: error._code)
                    self.authStatus.setLoginFail(errorCode: error._code, errorMessage: errorMessage)
                    self.postNotification(userInfo: [FaceIdAuth.status : self.authStatus])
                }
            }
        } else {
            
            guard let error = authError else {
                return
            }
            let errorMessage = self.errorMessageForFails(errorCode: error._code)
            self.authStatus.setLoginFail(errorCode: error._code, errorMessage: errorMessage)
            self.postNotification(userInfo: [FaceIdAuth.status : self.authStatus])
        }
    }
    
    
 
    
    func errorMessageForFails(errorCode: Int) -> String {
        
        var message = ""
        
        switch errorCode {
        case LAError.authenticationFailed.rawValue:
            message = "Authentication was not successful, because user failed to provide valid credentials"
            
        case LAError.appCancel.rawValue:
            message = "Authentication was canceled by application"
            
        case LAError.invalidContext.rawValue:
            message = "LAContext passed to this call has been previously invalidated"
            
        case LAError.notInteractive.rawValue:
            message = "Authentication failed, because it would require showing UI which has been forbidden by using interactionNotAllowed property"
            
        case LAError.passcodeNotSet.rawValue:
            message = "Authentication could not start, because passcode is not set on the device"
            
        case LAError.systemCancel.rawValue:
            message = "Authentication was canceled by system"
            
        case LAError.userCancel.rawValue:
            message = "Authentication was canceled by user"
            
        case LAError.userFallback.rawValue:
            message = "Authentication was canceled, because the user tapped the fallback button"
       
        case LAError.biometryNotAvailable.rawValue:
            message = "Authentication could not start, because biometry is not available on the device"
            
        case LAError.biometryLockout.rawValue:
            message = "Authentication was not successful, because there were too many failed biometry attempts and                          biometry is now locked"
            
        case LAError.biometryNotEnrolled.rawValue:
            message = "Authentication could not start, because biometric authentication is not enrolled"
    
        default:
            message = "error"
        }

        return message
    }
   
    func postNotification(userInfo: [String: FaceIdAuthStatus]) {
          NotificationCenter.default.post(name: .MTBiometricAuthenticationNotificationLoginStatus, object: self, userInfo: userInfo)
    }
    
    
}
