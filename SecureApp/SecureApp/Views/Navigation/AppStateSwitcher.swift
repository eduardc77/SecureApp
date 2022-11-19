//
//  AppStateSwitcher.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import SwiftUI

struct AppStateSwitcher: View {
   @EnvironmentObject private var authentication: UserAppState
   @EnvironmentObject private var keychainService: KeychainService
   @ObservedObject var settingsViewModel: SettingsViewModel
   @State private var isOnboardingPresented: Bool = false
   @Environment(\.colorScheme) private var colorScheme
   
   var body: some View {
      Group {
         if authentication.authState  == .authorized {
            if !keychainService.appLocked {
               AppTabView(settingsViewModel: settingsViewModel)
               
            } else {
               AppLockView(viewModel: settingsViewModel)
            }
         } else {
            LoginView(viewModel: LoginViewModel(authentication: authentication))
         }
      }
			.navigationViewStyle(.stack)
      .preferredColorScheme(settingsViewModel.appAppearance == 3 ? colorScheme : settingsViewModel.appAppearance == 1 ? .dark : .light)
      
      .onChange(of: keychainService.onBoardingSheetIsPresented) { newValue in
         isOnboardingPresented = newValue
      }
      
      .onAppear {
         if keychainService.isFirstLaunch {
            keychainService.onBoardingSheetIsPresented = true
         }
      }
      
      .sheet(isPresented: $isOnboardingPresented) {
         OnboardingView()
            .accentColor(settingsViewModel.colors[settingsViewModel.accentColorIndex])
      }
   }
}

struct AppStateSwitcher_Previews: PreviewProvider {
   static var previews: some View {
      AppStateSwitcher(settingsViewModel: SettingsViewModel())
			 .environmentObject(UserAppState())
			 .environmentObject(KeychainService())
   }
}
