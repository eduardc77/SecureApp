//
//  LockTimerPicker.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import SwiftUI

struct LockTimerPicker: View {
   @EnvironmentObject var appState: UserAppState
   
   var body: some View {
      Picker(selection: $appState.autoLockIndex,
             label: Label(
               title: { Text("Lock automatically") },
               icon: { Image(systemName: "lock").font(.title2) }),
             
             content: {
         Text("Immediately").tag(0)
         Text("1 minute").tag(1)
         Text("5 minutes").tag(2)
         Text("15 minutes").tag(3)
         Text("30 minutes").tag(4)
      })
   }
}

struct LockTimerPicker_Previews: PreviewProvider {
   static var previews: some View {
      LockTimerPicker()
         .environmentObject(UserAppState(authService: AuthService()))
   }
}
