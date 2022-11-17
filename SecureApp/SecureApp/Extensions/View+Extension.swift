//
//  View+Extension.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import SwiftUI

extension View {
   
   func animateForever(using animation: Animation = Animation.easeInOut(duration: 1.6), autoreverses: Bool = true, _ action: @escaping () -> Void) -> some View {
      return onAppear {
         withAnimation(animation.repeatForever(autoreverses: autoreverses)) {
            action()
         }
      }
   }
   
   func adaptiveImage(biometricType: SettingsViewModel.BiometricType) -> String {
      
      switch biometricType {
         case .none:
            return "key"
         case .touch:
            return "touchid"
         case .face:
            return "faceid"
         case .unknown:
            return "key"
      }
   }
   
   func adaptiveMessage(biometricType: SettingsViewModel.BiometricType) -> LocalizedStringKey  {
      
      switch biometricType {
         case .none:
            return "Unlock the app with iPhone passcode"
         case .touch:
            return "Unlock the app with Touch ID"
         case .face:
            return "Unlock the app with Face ID"
         case .unknown:
            return "Unlock the app with iPhone passcode"
      }
   }
}
