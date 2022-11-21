//
//  ThemeColorPicker.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import SwiftUI

struct ThemeColorPicker: View {
	@ObservedObject var settingsViewModel: SettingsViewModel
	
	var body: some View {
		Picker(selection: $settingsViewModel.accentColorIndex,
				 label: Label(
					title: { Text("Theme Color") },
					icon: { Image(systemName: "paintpalette").font(.title3) }),
				 
				 content: {
			Text("Indigo").tag(0)
			Text("Red").tag(1)
			Text("Blue").tag(2)
			Text("Green").tag(3)
			Text("Orange").tag(4)
			Text("Purple").tag(5)
			Text("Gray").tag(6)
		})
	}
}

struct AccentColorPicker_Previews: PreviewProvider {
	static var previews: some View {
		ThemeColorPicker(settingsViewModel: SettingsViewModel())
	}
}
