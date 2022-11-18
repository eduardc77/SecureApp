//
//  KeychainService.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import Foundation
import SwiftKeychainWrapper
import LocalAuthentication

enum BiometricType {
   case none
   case face
   case touch
   case unknown
}

final class KeychainService: ObservableObject {
   static let credentialsKey = "credentials"
   @Published var appLocked = false
   @Published var lockAppTimerIsRunning = false
   
   @Published var unlockMethodIsActive: Bool {
      didSet {
         UserDefaults.standard.set(unlockMethodIsActive, forKey: "biometricAuthentication")
      }
   }
   
   @Published var autoLock: Int {
      didSet {
         UserDefaults.standard.set(autoLock, forKey: "autoLock")
      }
   }
   
   static var biometricType: BiometricType {
      let authContext = LAContext()
      authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
      
      switch authContext.biometryType {
         case .none:
            return .none
         case .touchID:
            return .touch
         case .faceID:
            return .face
         @unknown default:
            return .none
      }
   }
   
   init() {
      unlockMethodIsActive = UserDefaults.standard.object(forKey: "biometricAuthentication") as? Bool ?? false
      autoLock = UserDefaults.standard.object(forKey: "autoLock") as? Int ?? 0
   }
   
   func requestBiometricUnlock(completion: @escaping (Result<Credentials, AuthenticationError>) -> Void) {
      let credentials = KeychainService.getCredentials()
      
      guard let credentials = credentials else {
         completion(.failure(.credentialsNotSaved))
         return
      }
      let context = LAContext()
      var error: NSError?
      let canEvaluate = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
      
      if let error = error {
         switch error.code {
            case -6:
               completion(.failure(.deniedAccess))
            case -7:
               completion(.failure(.noBiometricEnrolled))
            default:
               completion(.failure(.biometricError))
         }
         
         return
      }
      
      guard canEvaluate, context.biometryType != .none else { return }
      
      context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Need to access credentials.") { success, error in
         DispatchQueue.main.async {
            if error != nil {
               completion(.failure(.biometricError))
               
            } else {
               completion(.success(credentials))
            }
         }
      }
   }
   
   func lockAppInBackground() {
      lockAppTimerIsRunning = true
      let seconds: Int = 1 + autoLock * 60
      let dispatchAfter = DispatchTimeInterval.seconds(seconds)
      
      DispatchQueue.main.asyncAfter(deadline: .now() + dispatchAfter) {
         if self.lockAppTimerIsRunning {
            self.appLocked = true
         }
      }
   }
   
   static func getCredentials() -> Credentials? {
      if let myCredentialsString = KeychainWrapper.standard.string(forKey: Self.credentialsKey) {
         return Credentials.decode(myCredentialsString)
      } else {
         return nil
      }
   }
   
   static func saveCredentials(_ credentials: Credentials) -> Bool {
      if KeychainWrapper.standard.set(credentials.encoded(), forKey: Self.credentialsKey) {
         return true
      } else {
         return false
      }
   }
}
