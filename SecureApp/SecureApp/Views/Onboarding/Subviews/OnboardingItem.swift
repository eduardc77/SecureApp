//
//  OnboardingItem.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import SwiftUI

struct OnboardingItem: View {
	let image: String
	let text: LocalizedStringKey
	let title: LocalizedStringKey
	
	var body: some View {
		HStack(spacing: 24) {
			ZStack {
				Circle()
					.foregroundColor(.accentColor)
					.frame(minWidth: 50, maxWidth: 60, minHeight: 50, maxHeight: 60)
				
				Image(systemName: image)
					.frame(minWidth: 50, maxWidth: 60, minHeight: 50, maxHeight: 60)
					.font(.largeTitle)
					.foregroundColor(.white)
			}
			
			VStack(alignment: .leading, spacing: 6) {
				Text(title).bold()
				
				Text(text)
					.font(.body)
					.foregroundColor(.secondary)
					.lineLimit(4)
			}
		}
	}
}

struct OnboardingItem_Previews: PreviewProvider {
	static var previews: some View {
		OnboardingItem(image: "lock.square", text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", title: "Security")
	}
}
