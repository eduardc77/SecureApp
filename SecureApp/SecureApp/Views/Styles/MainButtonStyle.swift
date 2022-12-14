//
//  MainButtonStyle.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 18.11.2022.
//

import SwiftUI

struct MainButton: View {
	var title: String
	var buttonStyle: MainButtonStyle = .mainButtonStyle
	var action: () -> Void

	var body: some View {
		Button(title, action: action)
			.buttonStyle(buttonStyle)
	}
}

struct MainButtonStyle: ButtonStyle {
	var foregroundColor: Color = .white
	var backgroundColor: Color = .accentColor
	var height: CGFloat = 40
	var width: CGFloat = .infinity
	var font: Font = .body.weight(.medium)

	@Environment(\.isEnabled) private var isEnabled

	func makeBody(configuration: Configuration) -> some View {
		let currentForegroundColor = configuration.isPressed ? foregroundColor.opacity(0.3) : foregroundColor
		let currentBackgroundColor = configuration.isPressed ? backgroundColor.opacity(0.3) : backgroundColor

		HStack {
			Spacer()
			configuration.label
				.frame(maxWidth: width, maxHeight: height)
				.font(font)
			Spacer()
		}
		.foregroundColor(currentForegroundColor)
		.background(currentBackgroundColor.cornerRadius(8))
		.scaleEffect(configuration.isPressed ? 0.98 : 1)
		.animation(.easeInOut, value: configuration.isPressed)
		.buttonStyle(.plain)
		.contentShape(Rectangle())
	}
}

extension ButtonStyle where Self == MainButtonStyle {
	static var mainButtonStyle: MainButtonStyle { .init() }

	static func mainButtonStyle(foregroundColor: Color = .white, backgroundColor: Color = .accentColor, height: CGFloat = 40, width: CGFloat = .infinity, font: Font = .body.weight(.medium)) -> MainButtonStyle {
		MainButtonStyle(foregroundColor: foregroundColor, backgroundColor: backgroundColor, height: height, width: width, font: font)
	}

	static func plainButtonStyle(foregroundColor: Color = .accentColor, height: CGFloat = 40, width: CGFloat = .infinity, font: Font = .body.weight(.medium)) -> MainButtonStyle {
		MainButtonStyle(foregroundColor: foregroundColor, backgroundColor: .clear, height: height, width: width, font: font)
	}
}

struct ContinueButton_Previews: PreviewProvider {
	static var previews: some View {
			MainButton(title: "Continue") { }
				.padding()
	}
}
