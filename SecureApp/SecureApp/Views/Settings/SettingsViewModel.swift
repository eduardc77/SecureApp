//
//  SettingsViewModel.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import Foundation
import SwiftUI
import LocalAuthentication
import CoreHaptics

final class SettingsViewModel: ObservableObject {
	@Published var backgroundPrivacy = true
	@Published var copyToClipboard = false
	
	@AppStorage("biometricUnlockIsActive") var biometricUnlockIsActive: Bool = false
	@AppStorage("privacyMode") var privacyMode: Bool = true
	@AppStorage("ephemeralClipboard") var ephemeralClipboard: Bool = true
	@AppStorage("appAppearance") var appAppearance: Int = 3
	@AppStorage("accentColorIndex") var accentColorIndex: Int = 0
	
	let supportsHaptics: Bool = CHHapticEngine.capabilitiesForHardware().supportsHaptics
	let colors: [Color] = [.indigo, .red, .blue, .green, .orange, .purple, .gray]

	func copyToClipboard(notes: String) {
		let copiedNotes = notes
		
		if ephemeralClipboard {
			let expireDate = Date().addingTimeInterval(TimeInterval(60))
			UIPasteboard.general.setItems([[UIPasteboard.typeAutomatic: copiedNotes]],
													options: [UIPasteboard.OptionsKey.expirationDate: expireDate])
		} else {
			UIPasteboard.general.string = copiedNotes
		}
		
		copyToClipboard = true
		generateNotificationHapticFeedback()
	}
	
	func generateNotificationHapticFeedback() {
		let generator = UINotificationFeedbackGenerator()
		generator.notificationOccurred(.success)
	}
	
	func generateHapticFeedback() {
		let generator = UIImpactFeedbackGenerator(style: .medium)
		generator.impactOccurred(intensity: 1)
	}
}

