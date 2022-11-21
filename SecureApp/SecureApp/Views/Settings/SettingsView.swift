//
//  SettingsView.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import SwiftUI

struct SettingsView: View {
	@EnvironmentObject private var appState: UserAppState
	@ObservedObject var settingsViewModel: SettingsViewModel
	@Environment(\.colorScheme) private var colorScheme
	
	var body: some View {
		NavigationView {
			VStack {
				List {
					Section(header: Text("Security")) {
						UnlockMethodToggle(viewModel: settingsViewModel)
						
						if settingsViewModel.biometricUnlockIsActive {
							LockTimerPicker()
						}
						PrivacyModeToggle(settingsViewModel: settingsViewModel)
					}
					
					Section(footer: Text("If this option is active, the clipboard contents will be automatically cleared after 60 seconds.")) {
						EphemeralClipboardToggle(settingsViewModel: settingsViewModel)
					}
					
					Section(header: Text("Preferences")) {
						ColorSchemeToggle(settingsViewModel: settingsViewModel)
						
						ThemeColorPicker(settingsViewModel: settingsViewModel)
					}
					
					Section {
						Button(action: {
							withAnimation {
								DispatchQueue.main.async {
									appState.state = .loggedOut
								}
							}
						}, label: {
							
							Label(title: {
								Text("Logout")
									.foregroundColor(.primary)
							}, icon: {
								Image(systemName: "rectangle.portrait.and.arrow.right")
									.font(.title3)
							})
						})
					}
				}
				.listStyle(.insetGrouped)
				.navigationBarTitle("Settings")
			}
		}
		.onAppear {
			if settingsViewModel.appAppearance == 3 {
				settingsViewModel.appAppearance = colorScheme == .dark ? 1 : 0
			}
		}
	}
}


struct SettingsView_Previews: PreviewProvider {
	static var previews: some View {
		SettingsView(settingsViewModel: SettingsViewModel())
			.environmentObject(UserAppState(authService: AuthService()))
			.environmentObject(KeychainService())
	}
}
