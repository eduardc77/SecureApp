//
//  OnboardingView.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import SwiftUI

struct OnboardingView: View {
	@EnvironmentObject private var appState: UserAppState
	@Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
	@Environment(\.colorScheme) private var colorScheme
	
	var body: some View {
		VStack {
			VStack(alignment: .leading, spacing: 4) {
				Text("Welcome to")
					.font(.system(size: 44).weight(.heavy))
				
				Text("Secure Note")
					.font(.system(size: 36).weight(.heavy))
					.bold()
					.foregroundColor(.accentColor)
			}
			.frame(maxWidth: .infinity, alignment: .leading)
			.padding([.horizontal, .top], 40)
			.padding(.bottom)
			
			OnboardingPageView()
			
			Button {
				presentationMode.wrappedValue.dismiss()
				appState.isFirstLaunch = false
				
			} label: {
				Text("Continue")
			}
			.buttonStyle(.mainButtonStyle(height: 56))
			.padding(40)
		}
		.environment(\.colorScheme, colorScheme)
	}
}

struct OnboardingView_Previews: PreviewProvider {
	static var previews: some View {
		OnboardingView()
			.preferredColorScheme(.dark)
	}
}
