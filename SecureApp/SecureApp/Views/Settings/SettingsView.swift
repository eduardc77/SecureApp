//
//  SettingsView.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import SwiftUI

struct SettingsView: View {
   @ObservedObject var settingsViewModel: SettingsViewModel
   @State var biometricType: SettingsViewModel.BiometricType
   @State private var removePasswordAlert = false
   @State private var deletedPasswordsPopup = false
   
   var body: some View {
      NavigationView {
         VStack {
            Form {
               Section(header: Text("Security")) {
                  
                  UnlockMethodToggle(settingsViewModel: settingsViewModel,
                                     biometricType: biometricType)
                  
                  if settingsViewModel.unlockMethodIsActive {
                     LockTimerPicker(settingsViewModel: settingsViewModel)
                  }
                  
                  PrivacyModeToggle(settingsViewModel: settingsViewModel)
               }
               
               Section(header: Text(""), footer: Text("If this option is active, the clipboard contents will be automatically cleared after 60 seconds.")) {
                  
                  EphemeralClipboardToggle(settingsViewModel: settingsViewModel)   
               }
               
               Section(header: Text("Customisations")) {
                  AccentColorPicker(settingsViewModel: settingsViewModel)
               }
            }
            
            .onAppear(perform: {
               biometricType = settingsViewModel.biometricType()
            })
            
            .navigationBarTitle("Settings")
         }
      }
   }
}

struct SettingsView_Previews: PreviewProvider {
   static var previews: some View {
      SettingsView(settingsViewModel: SettingsViewModel(), biometricType: SettingsViewModel.BiometricType.face)
   }
}
