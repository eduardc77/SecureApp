//
//  LockTimerPicker.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import SwiftUI

struct LockTimerPicker: View {
	@EnvironmentObject var appState: AppState
	
	var body: some View {
		Picker(selection: $appState.autoLockIndex,
				 label: Label(
					title: { Text("Auto-Lock") },
					icon: { Image(systemName: "lock").font(.title2) }),
				 
				 content: {
			Text("Instantly").tag(0)
			Text("1 minute").tag(1)
			Text("5 minutes").tag(2)
			Text("15 minutes").tag(3)
			Text("30 minutes").tag(4)
		})
	}
}


// MARK: - Previews

struct LockTimerPicker_Previews: PreviewProvider {
	static var previews: some View {
		LockTimerPicker()
			.environmentObject(AppState(authService: AuthService()))
			.padding()
	}
}
