//
//  AppStateSwitcher.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import SwiftUI

struct AppStateSwitcher: View {
	@EnvironmentObject private var appState: AppState
	@ObservedObject var settingsViewModel: SettingsViewModel
	@State private var welcomeSheetPresented: Bool = false
	@Environment(\.colorScheme) private var colorScheme
	
	var body: some View {
		Group {
			if appState.state  == .authorized {
				if !appState.appLocked {
					AppTabView(settingsViewModel: settingsViewModel)
					
				} else {
					AppLockView(viewModel: settingsViewModel)
				}
			} else {
				LoginView(viewModel: LoginViewModel(appState: appState), settingsViewModel: settingsViewModel)
			}
		}
		.navigationViewStyle(.stack)

		.preferredColorScheme(settingsViewModel.appAppearance == 3 ? colorScheme : settingsViewModel.appAppearance == 1 ? .dark : .light)
		
		.onChange(of: appState.welcomeSheetIsPresented) { newValue in
			welcomeSheetPresented = newValue
		}
		
		.onAppear {
			if appState.isFirstLaunch {
				appState.welcomeSheetIsPresented = true
			}
		}
		
		.sheet(isPresented: $welcomeSheetPresented) {
			WelcomeView()
				.accentColor(settingsViewModel.colors[settingsViewModel.accentColorIndex])
		}
	}
}


// MARK: - Previews

struct AppStateSwitcher_Previews: PreviewProvider {
	static var previews: some View {
		AppStateSwitcher(settingsViewModel: SettingsViewModel())
			.environmentObject(AppState(authService: AuthService()))
	}
}
