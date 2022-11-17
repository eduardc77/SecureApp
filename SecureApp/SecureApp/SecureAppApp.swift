//
//  SecureAppApp.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import SwiftUI

@main
struct SecureAppApp: App {
   @StateObject var settingsViewModel = SettingsViewModel()
   @Environment(\.scenePhase) var scenePhase
   
   var body: some Scene {
      WindowGroup {
         AppStateSwitcher(settingsViewModel: settingsViewModel)
            .accentColor(settingsViewModel.colors[settingsViewModel.accentColorIndex])
      }
      
      .onChange(of: scenePhase) { newPhase in
         if newPhase == .inactive {
            if settingsViewModel.privacyMode && settingsViewModel.isUnlocked {
               settingsViewModel.backgroundPrivacy = true
            }
         }
         
         else if newPhase == .active {
            if settingsViewModel.privacyMode {
               settingsViewModel.backgroundPrivacy = false
            }
            settingsViewModel.lockAppTimerIsRunning = false
         }
         
         else if newPhase == .background {
            if settingsViewModel.privacyMode {
               settingsViewModel.backgroundPrivacy = false
            }
            if settingsViewModel.unlockMethodIsActive {
               settingsViewModel.lockAppInBackground()
            }
         }
      }
   }
}
