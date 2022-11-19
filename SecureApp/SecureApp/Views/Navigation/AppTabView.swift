//
//  AppTabView.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import SwiftUI

struct AppTabView: View {
   @EnvironmentObject private var keychainService: KeychainService
   @ObservedObject var settingsViewModel: SettingsViewModel
   
   var body: some View {
      
      TabView {
         NotesView(settingsViewModel: settingsViewModel)
            .tabItem {
               Label(title: { Text("Notes") },
                     icon: { Image(systemName: "square.and.pencil") })
            }
            .tag(0)
         
         SettingsView(settingsViewModel: settingsViewModel)
         
            .tabItem {
               Label(title: { Text("Settings") },
                     icon: { Image(systemName: "gear") })
            }
            .tag(1)
      }
   }
}

struct AppTabView_Previews: PreviewProvider {
   static var previews: some View {
      AppTabView(settingsViewModel: SettingsViewModel())
   }
}
