//
//  AppStateSwitcher.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import SwiftUI

struct AppStateSwitcher: View {
   @EnvironmentObject var authentication: Authentication
   @ObservedObject var settingsViewModel: SettingsViewModel
   @State var isOnboardingPresented: Bool = false
   
   var body: some View {
      Group {
         if !authentication.isValidated {
            LoginView()
            
         } else {
            if settingsViewModel.isUnlocked {
               if settingsViewModel.backgroundPrivacy {
                  PrivacyView(accentColor: settingsViewModel.colors[settingsViewModel.accentColorIndex])
               } else {
                  AppTabView(settingsViewModel: settingsViewModel)
               }
            } else {
               AuthenticationView(viewModel: settingsViewModel, biometricType: settingsViewModel.biometricType(), settingsViewModel: settingsViewModel)
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
         OnboardingView(settingsViewModel: settingsViewModel, biometricType: settingsViewModel.biometricType())
      }
   }
}

struct AppStateSwitcher_Previews: PreviewProvider {
   static var previews: some View {
      AppStateSwitcher(settingsViewModel: SettingsViewModel())
   }
}
