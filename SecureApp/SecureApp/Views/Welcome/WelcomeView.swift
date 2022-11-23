//
//  WelcomeView.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import SwiftUI

struct WelcomeView: View {
	@EnvironmentObject private var appState: AppState
	@Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
	@Environment(\.colorScheme) private var colorScheme
	
	var body: some View {
		VStack(spacing: 0) {
			VStack(alignment: .leading) {
				Text("Welcome to")
				Text("Secure Note")
					.foregroundColor(.accentColor)
			}
			.font(.system(size: 42).weight(.heavy))
			.frame(maxWidth: .infinity, alignment: .leading)
			.padding([.horizontal, .top], 30)

			WelcomePageView()

			Spacer()

			MainButton(title: "Continue", buttonStyle: .mainButtonStyle(height: 48)) {
				presentationMode.wrappedValue.dismiss()
				appState.isFirstLaunch = false
			}
			.padding(30)
		}

		.environment(\.colorScheme, colorScheme)
	}
}


// MARK: - Previews

struct WelcomeView_Previews: PreviewProvider {
	static var previews: some View {
		WelcomeView()
			.preferredColorScheme(.dark)
	}
}
