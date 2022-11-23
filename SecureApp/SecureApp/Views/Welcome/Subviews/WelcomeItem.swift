//
//  WelcomeItem.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import SwiftUI

struct WelcomeItem: View {
	let image: String
	let text: LocalizedStringKey
	let title: LocalizedStringKey
	
	var body: some View {
		HStack(spacing: 18) {
			ZStack {
				Circle()
					.foregroundColor(.accentColor)
					.frame(minWidth: 48, maxWidth: 54, minHeight: 48, maxHeight: 54)
				
				Image(systemName: image)
					.frame(minWidth: 48, maxWidth: 54, minHeight: 48, maxHeight: 54)
					.font(.largeTitle)
					.foregroundColor(.white)
			}
			
			VStack(alignment: .leading) {
				Text(title).bold()
				
				Text(text)
					.font(.body)
					.foregroundColor(.secondary)
			}
		}
	}
}


// MARK: - Previews

struct WelcomeItem_Previews: PreviewProvider {
	static var previews: some View {
		WelcomeItem(image: "lock.square", text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", title: "Security")
	}
}
