//
//  EphemeralClipboardToggle.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import SwiftUI

struct EphemeralClipboardToggle: View {
   
   @ObservedObject var settingsViewModel: SettingsViewModel
   
   var body: some View {
      
      Toggle(isOn: $settingsViewModel.ephemeralClipboard, label: {
         Label(
            title: { Text("Ephemeral clipboard") },
            icon: { Image(systemName: "timer") })
      })
      .toggleStyle(SwitchToggleStyle(tint: settingsViewModel.colors[settingsViewModel.accentColorIndex]))
      
   }
}

struct EphemeralClipboardToggle_Previews: PreviewProvider {
   static var previews: some View {
      EphemeralClipboardToggle(settingsViewModel: SettingsViewModel())
   }
}
