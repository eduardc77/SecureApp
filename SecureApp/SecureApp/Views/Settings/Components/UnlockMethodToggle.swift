//
//  UnlockMethodToggle.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import SwiftUI

struct UnlockMethodToggle: View {
   
   @ObservedObject var settingsViewModel: SettingsViewModel
   var biometricType: SettingsViewModel.BiometricType
   
   var body: some View {
      Toggle(isOn: $settingsViewModel.faceIdToggle,
             label: {
         Label(title: { biometricType == .face ? Text("Unlock with Face ID") : biometricType == .touch ? Text("Unlock with Touch ID") : Text("Unlock with device passcode") },
               icon: { biometricType == .face ?
            Image(systemName: "faceid")                    : biometricType == .touch ? Image(systemName: "touchid") : Image(systemName: "key.fill") }
         )
      })
      .toggleStyle(SwitchToggleStyle(tint: settingsViewModel.colors[settingsViewModel.accentColorIndex]))
      
      .onChange(of: settingsViewModel.faceIdToggle, perform: { _ in
         
         if settingsViewModel.faceIdToggle {
            settingsViewModel.addBiometricAuthentication()
            print("Waiting for authentication")
         }
         
         if !settingsViewModel.faceIdToggle {
            settingsViewModel.turnOffBiometricAuthentication()
         }
      })
   }
}

struct UnlockMethodToggle_Previews: PreviewProvider {
   static var previews: some View {
      UnlockMethodToggle(settingsViewModel: SettingsViewModel(), biometricType: SettingsViewModel.BiometricType.face)
   }
}
