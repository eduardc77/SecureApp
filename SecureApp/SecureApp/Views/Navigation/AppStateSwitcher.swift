//
//  AppStateSwitcher.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import SwiftUI

struct AppStateSwitcher: View {
   @EnvironmentObject var authentication: UserAppState
   @EnvironmentObject var keychainService: KeychainService
   @ObservedObject var settingsViewModel: SettingsViewModel
   @State var isOnboardingPresented: Bool = false
   
   var body: some View {
      Group {
         if authentication.currentStatus  == .loggedOut {
            LoginView()
            
         } else {
            if !keychainService.appLocked {
               if settingsViewModel.backgroundPrivacy {
                  PrivacyView()
               } else {
                  AppTabView(settingsViewModel: settingsViewModel)
               }

            } else {
               AppLockView(viewModel: settingsViewModel)
            }
         }
      }
      
      .onChange(of: settingsViewModel.onBoardingSheetIsPresented) { newValue in
         isOnboardingPresented = newValue
      }
      
      .onAppear(perform: {
         if settingsViewModel.isFirstLaunch {
            settingsViewModel.onBoardingSheetIsPresented = true
         }
      })
      
      .sheet(isPresented: $isOnboardingPresented,
             onDismiss: { isOnboardingPresented = false }) {
         OnboardingView(settingsViewModel: settingsViewModel)
            .accentColor(settingsViewModel.colors[settingsViewModel.accentColorIndex])
      }
   }
}

struct AppStateSwitcher_Previews: PreviewProvider {
   static var previews: some View {
      AppStateSwitcher(settingsViewModel: SettingsViewModel())
   }
}
