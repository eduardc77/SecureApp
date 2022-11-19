//
//  SecureApp.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import SwiftUI

@main
struct SecureApp: App {
   @StateObject private var authentication = UserAppState()
   @StateObject private var keychainService = KeychainService()
   @StateObject private var settingsViewModel = SettingsViewModel()
   @Environment(\.scenePhase) private var scenePhase
   
   
   var body: some Scene {
      WindowGroup {
         AppStateSwitcher(settingsViewModel: settingsViewModel)
            .environmentObject(authentication)
            .environmentObject(keychainService)

            .overlay((settingsViewModel.backgroundPrivacy && !authentication.authState.isLoading && !keychainService.appLocked) ? PrivacyView() : nil)
      
            .accentColor(settingsViewModel.colors[settingsViewModel.accentColorIndex])
      }
      
      .onChange(of: scenePhase) { newPhase in
         if newPhase == .inactive {
            if settingsViewModel.privacyMode, !keychainService.appLocked, !authentication.authState.isLoading {
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
            if keychainService.biometricUnlockIsActive, authentication.authState == .authorized {
               keychainService.lockAppInBackground()
            }
         }
      }
   }
}
