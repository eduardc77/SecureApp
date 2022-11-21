//
//  SecureApp.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import SwiftUI

@main
struct SecureApp: App {
	@StateObject private var appState = UserAppState(authService: AuthService())
	@StateObject private var settingsViewModel = SettingsViewModel()
	@Environment(\.scenePhase) private var scenePhase

	var body: some Scene {
		WindowGroup {
			AppStateSwitcher(settingsViewModel: settingsViewModel)
				.environmentObject(appState)
				.overlay((settingsViewModel.backgroundPrivacy && !appState.state.isLoading && !appState.appLocked) ? LogoView() : nil)
				.accentColor(settingsViewModel.colors[settingsViewModel.accentColorIndex])
		}

		.onChange(of: scenePhase) { newPhase in
			if newPhase == .inactive {
				if settingsViewModel.privacyMode, !appState.appLocked, !appState.state.isLoading {
					settingsViewModel.backgroundPrivacy = true
				}
			}



			else if newPhase == .background {
				if settingsViewModel.privacyMode {
					settingsViewModel.backgroundPrivacy = false
				}
				if settingsViewModel.biometricUnlockIsActive, appState.state == .authorized {
					appState.lockAppInBackground()
				}
			}

			else if newPhase == .active {
				if settingsViewModel.privacyMode {
					settingsViewModel.backgroundPrivacy = false
				}
				appState.lockAppTimerIsRunning = false
			}
		}
	}
}
