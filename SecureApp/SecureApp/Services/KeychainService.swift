//
//  KeychainService.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import SwiftUI
import SwiftKeychainWrapper
import LocalAuthentication

enum BiometricType {
   case none
   case face
   case touch
   case unknown
}

final class KeychainService: ObservableObject {
   @Published var appLocked = false
   @Published var lockAppTimerIsRunning = false
   @Published var onBoardingSheetIsPresented = false
   
   @AppStorage("biometricUnlockIsActive") var biometricUnlockIsActive: Bool = true
   @AppStorage("autoLockIndex") var autoLockIndex: Int = 0
   @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true
   
   static let credentialsStorageKey = "credentials"
   
   static var biometricType: BiometricType {
      let authContext = LAContext()
      authContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
      
      switch authContext.biometryType {
         case .none:
            return .none
         case .touchID:
            return .touch
         case .faceID:
            return .face
         @unknown default:
            return .unknown
      }
   }
   
   func biometricAuthentication(completion: ((Result<Credentials, AuthenticationError>) -> Void)? = nil) {
      let credentials = KeychainService.getCredentials()
      
      guard let credentials = credentials else {
         completion?(.failure(.credentialsNotSaved))
         return
      }
      
      let context = LAContext()
      var error: NSError?
      let reason = "Required for logging in to the app."
      
      if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
         
         if let error = error {
            switch error.code {
               case -6:
                  completion?(.failure(.deniedAccess))
               case -7:
                  completion?(.failure(.noBiometricEnrolled))
               default:
                  completion?(.failure(.biometricError))
            }
            
            return
         }
         
         context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, error in
            DispatchQueue.main.async {
               if success {
                  print("Success")
                  self.appLocked = false
                  completion?(.success(credentials))
               } else {
                  self.appLocked = true
                  print("Failed to authenticate using Biometrics.")
                  completion?(.failure(.biometricError))
               }
            }
         }
      } else {
         print("No Device Owner Authentication")
      }
   }
   
   func toggleBiometricAuthentication(_ value: Bool) {
      biometricUnlockIsActive = value ? true : false
   }
   
   func lockAppInBackground() {
      lockAppTimerIsRunning = true
      let seconds: Int = 1 + autoLockIndex * 60
      let dispatchAfter = DispatchTimeInterval.seconds(seconds)
      
      DispatchQueue.main.asyncAfter(deadline: .now() + dispatchAfter) {
         if self.lockAppTimerIsRunning {
            self.appLocked = true
         }
      }
   }
   
   static func getCredentials() -> Credentials? {
      if let myCredentialsString = KeychainWrapper.standard.string(forKey: Self.credentialsStorageKey) {
         return Credentials.decode(myCredentialsString)
      } else {
         return nil
      }
   }
   
   static func saveCredentials(_ credentials: Credentials) -> Bool {
      if KeychainWrapper.standard.set(credentials.encoded(), forKey: Self.credentialsStorageKey) {
         return true
      } else {
         return false
      }
   }
}
