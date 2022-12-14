//
//  EntryField.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import SwiftUI

struct EntryField: View {
	@Binding var text: String
	var systemName: String
	var placeholder: String
	var prompt: String = ""
	var isSecure = false
	
	var body: some View {
		VStack(alignment: .leading) {
			HStack {
				Image(systemName: systemName)
					.foregroundColor(.accentColor)
					.frame(width: 20)
				
				if isSecure {
					SecureField(placeholder, text: $text)
					
				} else {
					TextField(placeholder, text: $text)
				}
			}
			.autocapitalization(.none)
			.padding(10)
			.overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.separator, lineWidth: 1))
			.background(Color.background)
			.cornerRadius(6)
			
			if !prompt.isEmpty {
				Text(prompt)
					.fixedSize(horizontal: false, vertical: true)
					.foregroundColor(.red)
					.font(.caption)
			}
		}
	}
}


// MARK: - Previews


struct EntryField_Previews: PreviewProvider {
	static var previews: some View {
		EntryField(text: .constant(""),  systemName: "envelope", placeholder: "Email Address", prompt: "Enter a valid email address")
			.padding()
	}
}
