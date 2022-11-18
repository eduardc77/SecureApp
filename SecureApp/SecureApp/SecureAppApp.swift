//
//  SecureAppApp.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import SwiftUI

@main
struct SecureAppApp: App {
   @StateObject var authentication = UserAppState()
   @StateObject var keychainService = KeychainService()
   @StateObject var settingsViewModel = SettingsViewModel()
   @Environment(\.scenePhase) var scenePhase
   
   var body: some Scene {
      WindowGroup {
         AppStateSwitcher(settingsViewModel: settingsViewModel)
            .environmentObject(authentication)
            .environmentObject(keychainService)
            .accentColor(settingsViewModel.colors[settingsViewModel.accentColorIndex])
      }
      
      .onChange(of: scenePhase) { newPhase in
         if newPhase == .inactive {
            if settingsViewModel.privacyMode && !keychainService.appLocked {
               settingsViewModel.backgroundPrivacy = true
            }
         }
         
         else if newPhase == .active {
            if settingsViewModel.privacyMode {
               settingsViewModel.backgroundPrivacy = false
            }
            keychainService.lockAppTimerIsRunning = false
         }
         
         else if newPhase == .background {
            if settingsViewModel.privacyMode {
               settingsViewModel.backgroundPrivacy = false
            }
            if keychainService.unlockMethodIsActive {
               keychainService.lockAppInBackground()
            }
         }
      }
   }
}
