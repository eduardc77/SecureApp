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
         VStack {
            TextEditor(text: $notesText)
               .border(Color.accentColor.opacity(0.6))
               .cornerRadius(3)
               .padding()
            
            Spacer()
         }
         
         .toast(isPresenting: $settingsViewModel.copyToClipboard) {
            AlertToast(displayMode: .notification, type: settingsViewModel.ephemeralClipboard ? .systemImage("timer", .white) : .complete(.white), title: "Copied to clipboard", subTitle: settingsViewModel.ephemeralClipboard ? ("(60sec)") : nil, style: .style(backgroundColor: Color.accentColor, titleColor: .white, subTitleColor: .white))
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
         self.dismissKeyboard()
      }
   }
}

struct NotesView_Previews: PreviewProvider {
   static var previews: some View {
      NotesView(settingsViewModel: SettingsViewModel())
   }
}
