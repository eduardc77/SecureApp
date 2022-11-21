//
//  AppStateSwitcher.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import SwiftUI

struct AppStateSwitcher: View {
	@EnvironmentObject private var appState: UserAppState
	@ObservedObject var settingsViewModel: SettingsViewModel
	@State private var isOnboardingPresented: Bool = false
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
		
		.onChange(of: appState.onBoardingSheetIsPresented) { newValue in
			isOnboardingPresented = newValue
		}
		
		.onAppear {
			if appState.isFirstLaunch {
				appState.onBoardingSheetIsPresented = true
			}
		}
		
		.sheet(isPresented: $isOnboardingPresented) {
			OnboardingView()
				.accentColor(settingsViewModel.colors[settingsViewModel.accentColorIndex])
		}
	}
}

struct AppStateSwitcher_Previews: PreviewProvider {
	static var previews: some View {
		AppStateSwitcher(settingsViewModel: SettingsViewModel())
			.environmentObject(UserAppState(authService: AuthService()))
	}
}
