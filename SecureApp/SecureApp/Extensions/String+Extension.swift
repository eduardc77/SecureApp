//
//  View+Extension.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import SwiftUI

extension String {
   static var adaptiveBiometricImage: String {
      switch
      KeychainService.biometricType {
         case .none:
            return "key"
         case .touch:
            return "touchid"
         case .face:
            return "faceid"
         case .unknown:
            return "key"
      }
   }
   
   static var adaptiveBiometricDescription: String  {
      switch
      KeychainService.biometricType {
         case .none:
            return "Unlock the app with iPhone passcode"
         case .touch:
            return "Unlock the app with Touch ID"
         case .face:
            return "Unlock the app with Face ID"
         case .unknown:
            return "Unlock the app with iPhone passcode"
      }
   }
   
   static var adaptiveBiometricMessage: String  {
      switch KeychainService.biometricType {
         case .none:
            return "Unlock with iPhone passcode"
         case .touch:
            return "Unlock with Touch ID"
         case .face:
            return "Unlock with Face ID"
         case .unknown:
            return "Unlock with iPhone passcode"
      }
   }
   
   static var adaptiveBiometricTitle: String  {
      switch KeychainService.biometricType {
         case .none:
            return "iPhone Passcode"
         case .touch:
            return "Touch ID"
         case .face:
            return "Face ID"
         case .unknown:
            return "iPhone Passcode"
      }
   }
}
