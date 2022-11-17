//
//  PrivacyModeToggle.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import SwiftUI

struct PrivacyModeToggle: View {
   @ObservedObject var settingsViewModel: SettingsViewModel
   
   var body: some View {
      Toggle(isOn: $settingsViewModel.privacyMode,
             label: {
         Label(title: { Text("Background Privacy") },
               icon: { Image(systemName: "eye.slash").font(.title3) })
      })
      .toggleStyle(SwitchToggleStyle(tint: settingsViewModel.colors[settingsViewModel.accentColorIndex]))
   }
}

struct PrivacyModeToggle_Previews: PreviewProvider {
   static var previews: some View {
      PrivacyModeToggle(settingsViewModel: SettingsViewModel())
   }
}
