//
//  AccentColorPicker.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import SwiftUI

struct AccentColorPicker: View {
   
   @ObservedObject var settingsViewModel: SettingsViewModel
   
   var body: some View {
      Picker(selection: $settingsViewModel.accentColorIndex,
             label: Label(
               title: { Text("App Accent Color") },
               icon: { Image(systemName: "paintpalette.fill") }),
             
             content: {
         Text("Purple").tag(0)
         Text("Red").tag(1)
         Text("Blue").tag(2)
         Text("Green").tag(3)
         Text("Orange").tag(4)
         Text("Gray").tag(5)
      })
   }
}

struct AccentColorPicker_Previews: PreviewProvider {
   static var previews: some View {
      AccentColorPicker(settingsViewModel: SettingsViewModel())
   }
}
