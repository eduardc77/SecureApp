//
//  NotesView.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import SwiftUI

struct NotesView: View {
	@ObservedObject var settingsViewModel: SettingsViewModel
	@State private var notesText: String = ""
	
	var body: some View {
		NavigationView {
			ZStack {
				Color.groupedBackground.ignoresSafeArea()
				
				VStack {
					TextEditor(text: $notesText)
						.cornerRadius(6)
						.overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.accentColor.opacity(0.6), lineWidth: 1))
						.padding()
					
					Spacer()
				}
			}
			.popup(isPresenting: $settingsViewModel.copyToClipboard) {
				PopupView(displayMode: .notification, type: settingsViewModel.ephemeralClipboard ? .systemImage("timer", .white) : .complete(.white), title: "Copied to clipboard", subTitle: settingsViewModel.ephemeralClipboard ? ("(60sec)") : nil, style: .style(backgroundColor: Color.accentColor, titleColor: .white, subTitleColor: .white))
			}
			
			.navigationTitle("Notes")
			
			.toolbar {
				Button {
					settingsViewModel.copyToClipboard(notes: notesText)
				} label: {
					Image(systemName: "doc.on.doc")
						.font(.body)
				}
			}
		}
		.onTapGesture {
			UIApplication.shared.endEditing()
		}
	}
}


// MARK: - Previews

struct NotesView_Previews: PreviewProvider {
	static var previews: some View {
		NotesView(settingsViewModel: SettingsViewModel())
	}
}
