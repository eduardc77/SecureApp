//
//  OnboardingView.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import SwiftUI

struct OnboardingView: View {
	@EnvironmentObject private var appState: AppState
	@Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
	@Environment(\.colorScheme) private var colorScheme
	
	var body: some View {
		VStack {
			VStack(alignment: .leading, spacing: 0) {
				Text("Welcome to")
					.font(.system(size: 44).weight(.heavy))
				
				Text("Secure Note")
					.font(.system(size: 38).weight(.heavy))
					.bold()
					.foregroundColor(.accentColor)
			}
			.frame(maxWidth: .infinity, alignment: .leading)
			.padding([.horizontal, .top], 32)

			OnboardingPageView()
			Spacer()

			MainButton(title: "Continue", buttonStyle: .mainButtonStyle(height: 56)) {
				presentationMode.wrappedValue.dismiss()
				appState.isFirstLaunch = false
			}
			.padding([.bottom, .horizontal], 32)
		}
		.environment(\.colorScheme, colorScheme)
	}
}


// MARK: - Previews

struct OnboardingView_Previews: PreviewProvider {
	static var previews: some View {
		OnboardingView()
			.preferredColorScheme(.dark)
	}
}
