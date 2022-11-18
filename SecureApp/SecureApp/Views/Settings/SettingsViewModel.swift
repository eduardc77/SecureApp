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
      accentColorIndex = UserDefaults.standard.object(forKey: "accentColorIndex") as? Int ?? 0
      supportsHaptics = hapticCapability.supportsHaptics
      isFirstLaunch = UserDefaults.standard.object(forKey: "isFirstLaunch") as? Bool ?? true
      privacyMode = UserDefaults.standard.object(forKey: "privacyMode") as? Bool ?? true
      ephemeralClipboard = UserDefaults.standard.object(forKey: "ephemeralClipboard") as? Bool ?? true
   }
   
   var supportsHaptics: Bool = false
   let hapticCapability = CHHapticEngine.capabilitiesForHardware()
   var colors: [Color] = [.purple, .red, .blue, .green, .orange, .secondary]
   
   @Published var copyToClipboard = false
   @Published var onBoardingSheetIsPresented = false
   @Published var backgroundPrivacy = true
   @AppStorage("isDarkMode") var appAppearance: String = "Auto"
   @AppStorage("appAppearanceToggle") var appAppearanceToggle: Bool = false
   
   //UserDefaults values
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

   
   func generateNotificationHapticFeedback() {
      let generator = UINotificationFeedbackGenerator()
      generator.notificationOccurred(.success)
   }
   
   func generateHapticFeedback() {
      let generator = UIImpactFeedbackGenerator(style: .medium)
      generator.impactOccurred(intensity: 1)
   }
}

