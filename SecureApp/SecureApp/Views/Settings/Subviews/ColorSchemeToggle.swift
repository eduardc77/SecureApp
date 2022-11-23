//
//  ColorSchemeToggle.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 18.11.2022.
//

import SwiftUI

struct ColorSchemeToggle: View {
	@ObservedObject var settingsViewModel: SettingsViewModel
	
	var body: some View {
		HStack {
			Label(title: { Text("Appearance") },
					icon: { Image(systemName: "moonphase.first.quarter").font(.title3) })
			Spacer()

			Picker(selection: $settingsViewModel.appAppearance, label: Text("App Appearance")) {
				Image(systemName: "sun.max").tag(0)
				Image(systemName: "moon").tag(1)
			}
			.frame(maxWidth: 120)
			.pickerStyle(.segmented)
		}
	}
}


// MARK: - Previews

struct ColorSchemeToggle_Previews: PreviewProvider {
	static var previews: some View {
		EphemeralClipboardToggle(settingsViewModel: SettingsViewModel())
			.padding()
	}
}
