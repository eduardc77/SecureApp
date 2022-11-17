//
//  SettingsView.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import SwiftUI

struct SettingsView: View {
   @EnvironmentObject var authentication: Authentication
   @ObservedObject var settingsViewModel: SettingsViewModel
   @State var biometricType: SettingsViewModel.BiometricType
   
   var body: some View {
      NavigationView {
         VStack {
            List {
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
               
               Section {
                  Button(action: {
                     withAnimation {
                        authentication.updateValidation(success: false)
                     }
                  }, label: {
                     
                     Label(title: {
                        Text("Logout")
                           .foregroundColor(.primary)
                     }, icon: {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                           .font(.title3)
                     })
                     
                  })
               }
            }
            
            .onAppear(perform: {
               biometricType = settingsViewModel.biometricType()
            })
            .listStyle(.insetGrouped)
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
