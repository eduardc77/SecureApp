//
//  UnlockMethodToggle.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import SwiftUI

struct UnlockMethodToggle: View {
	@EnvironmentObject private var appState: UserAppState
   @ObservedObject var viewModel: SettingsViewModel
   
   var body: some View {
      Toggle(isOn: $viewModel.biometricUnlockIsActive,
             label: {
         
         Label(title: {
            switch UserAppState.biometricType {
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
               switch UserAppState.biometricType {
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
      
      .onChange(of: viewModel.biometricUnlockIsActive, perform: { unlockMethodIsActive in
         
         if unlockMethodIsActive {
				appState.biometricAuthentication { result in
               switch result {
                  case .success:
						viewModel.biometricUnlockIsActive = true
                  case .failure:
						viewModel.biometricUnlockIsActive = false
               }
            }
         } else {
				viewModel.biometricUnlockIsActive = false
         }
      })
   }
}

struct UnlockMethodToggle_Previews: PreviewProvider {
   static var previews: some View {
		UnlockMethodToggle(viewModel: SettingsViewModel())
   }
}
