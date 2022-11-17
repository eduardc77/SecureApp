//
//  SettingsViewModel.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import Foundation
import SwiftUI
import LocalAuthentication
import CoreHaptics

final class SettingsViewModel: ObservableObject {
   
   init() {
      unlockMethodIsActive = UserDefaults.standard.object(forKey: "biometricAuthentication") as? Bool ?? false
      faceIdToggle = UserDefaults.standard.object(forKey: "faceIdToggle") as? Bool ?? false
      accentColorIndex = UserDefaults.standard.object(forKey: "accentColorIndex") as? Int ?? 0
      supportsHaptics = hapticCapability.supportsHaptics
      isFirstLaunch = UserDefaults.standard.object(forKey: "isFirstLaunch") as? Bool ?? true
      autoLock = UserDefaults.standard.object(forKey: "autoLock") as? Int ?? 1
      privacyMode = UserDefaults.standard.object(forKey: "privacyMode") as? Bool ?? true
      ephemeralClipboard = UserDefaults.standard.object(forKey: "ephemeralClipboard") as? Bool ?? true
   }
   
   var supportsHaptics: Bool = false
   let hapticCapability = CHHapticEngine.capabilitiesForHardware()
   var colors: [Color] = [.purple, .red, .blue, .green, .orange, .secondary]
   
   @Published var copyToClipboard = false
   @Published var isUnlocked = false
   @Published var onBoardingSheetIsPresented = false
   @Published var backgroundPrivacy = true
   @Published var lockAppTimerIsRunning = false
   @AppStorage("isDarkMode") var appAppearance: String = "Auto"
   @AppStorage("appAppearanceToggle") var appAppearanceToggle: Bool = false
   
   //UserDefaults values
   @Published var autoLock: Int {
      didSet {
         UserDefaults.standard.set(autoLock, forKey: "autoLock")
      }
   }
   
   @Published var ephemeralClipboard: Bool {
      didSet {
         UserDefaults.standard.set(ephemeralClipboard, forKey: "ephemeralClipboard")
      }
   }
   
   @Published var privacyMode: Bool {
      didSet {
         UserDefaults.standard.set(privacyMode, forKey: "privacyMode")
      }
   }
   
   @Published var isFirstLaunch: Bool {
      didSet {
         UserDefaults.standard.set(isFirstLaunch, forKey: "isFirstLaunch")
      }
   }
   
   @Published var accentColorIndex: Int {
      didSet {
         UserDefaults.standard.set(accentColorIndex, forKey: "accentColorIndex")
      }
   }
   
   @Published var faceIdToggle: Bool {
      didSet {
         UserDefaults.standard.set(faceIdToggle, forKey: "faceIdToggle")
      }
   }
   
   @Published var unlockMethodIsActive: Bool {
      didSet {
         UserDefaults.standard.set(unlockMethodIsActive, forKey: "biometricAuthentication")
      }
   }
   
   func copyToClipboard(notes: String) {
      let copiedNotes = notes
      
      if ephemeralClipboard {
         let expireDate = Date().addingTimeInterval(TimeInterval(60))
         UIPasteboard.general.setItems([[UIPasteboard.typeAutomatic: copiedNotes]],
                                       options: [UIPasteboard.OptionsKey.expirationDate: expireDate])
      } else {
         UIPasteboard.general.string = copiedNotes
      }
      
      copyToClipboard = true
      generateNotificationHapticFeedback()
   }
   
   func biometricType() -> BiometricType {
      let authContext = LAContext()
      let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
      
      switch(authContext.biometryType) {
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
   
   enum BiometricType {
      case none
      case touch
      case face
      case unknown
   }
   
   func biometricAuthentication() -> Bool {
      let context = LAContext()
      context.localizedFallbackTitle = "Login to the app."
      var error: NSError?
      let reason = "Login to the app."
      
      if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
         context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
            
            DispatchQueue.main.async {
               if success {
                  print("success")
                  self.isUnlocked = true
               } else {
                  self.isUnlocked = false
                  print("Failed to authenticate")
               }
            }
         }
      } else {
         print("No biometrics")
      }
      return isUnlocked
   }
   
   func addBiometricAuthentication() {
      let context = LAContext()
      var error: NSError?
      let reason = "Login to the app."
      context.localizedFallbackTitle = "Login to the app."
      
      if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
         context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
            DispatchQueue.main.async {
               if success {
                  print("Success")
                  self.unlockMethodIsActive = true
                  
               } else {
                  self.faceIdToggle = false
                  self.unlockMethodIsActive = false
                  print("Failed to authenticate")
               }
            }
         }
      } else {
         print("No biometrics")
         unlockMethodIsActive = false
         
      }
   }
   
   func turnOffBiometricAuthentication() {
      unlockMethodIsActive = false
   }
   
   func lockAppInBackground() {
      lockAppTimerIsRunning = true
      let seconds:Int = 1 + autoLock * 60
      let dispatchAfter = DispatchTimeInterval.seconds(seconds)
      
      DispatchQueue.main.asyncAfter(deadline: .now() + dispatchAfter) {
         if self.lockAppTimerIsRunning {
            self.isUnlocked = false
         }
      }
   }
   
   func generateNotificationHapticFeedback() {
      let generator = UINotificationFeedbackGenerator()
      generator.notificationOccurred(.success)
   }
   
   func generateHapticFeedback() {
      let generator = UIImpactFeedbackGenerator(style: .medium)
      generator.impactOccurred(intensity: 1)
   }
}

