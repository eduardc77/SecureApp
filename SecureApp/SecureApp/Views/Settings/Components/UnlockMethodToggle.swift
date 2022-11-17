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
         
         Label(title: {
            switch biometricType {
               case .none:
                  Text("Unlock with device passcode")
               case .touch:
                  Text("Unlock with Touch ID")
               case .face:
                  Text("Unlock with Face ID")
               case .unknown:
                  Text("Unlock with device passcode")
            }
         }, icon: {
            Group {
               switch biometricType {
                  case .none:
                     Image(systemName: "key.viewfinder")
                  case .touch:
                     Image(systemName: "touchid")
                  case .face:
                     Image(systemName: "faceid")
                  case .unknown:
                     Image(systemName: "key.viewfinder")
               }
            }
            .font(.title2)
         })
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
