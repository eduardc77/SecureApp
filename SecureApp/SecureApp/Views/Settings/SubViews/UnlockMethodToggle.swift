//
//  UnlockMethodToggle.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import SwiftUI

struct UnlockMethodToggle: View {
   @EnvironmentObject var keychainService: KeychainService
 
   var body: some View {
      Toggle(isOn: $keychainService.unlockMethodIsActive,
             label: {
         
         Label(title: {
            switch KeychainService.biometricType {
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
               switch KeychainService.biometricType {
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
      .toggleStyle(SwitchToggleStyle(tint: Color.accentColor))
      
      .onChange(of: keychainService.unlockMethodIsActive, perform: { unlockMethodIsActive in
         
         if unlockMethodIsActive {
            keychainService.requestBiometricUnlock { (result: Result<Credentials, AuthenticationError>) in
               switch result {
                  case .success:
                     keychainService.unlockMethodIsActive = true
                  case .failure:
                     keychainService.unlockMethodIsActive = false
               }
            }
         } else {
            keychainService.unlockMethodIsActive = false
         }
      })
   }
}

struct UnlockMethodToggle_Previews: PreviewProvider {
   static var previews: some View {
      UnlockMethodToggle()
   }
}