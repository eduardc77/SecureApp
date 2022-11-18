//
//  NotesView.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import SwiftUI

struct NotesView: View {
   @ObservedObject var settingsViewModel: SettingsViewModel
   @State var notesText: String = ""
   
   var body: some View {
      NavigationView {
         VStack {
            TextEditor(text: $notesText)
               .border(.gray)
               .cornerRadius(3)
               .padding()
            
            Spacer()
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
         
         .popup(isPresented: $settingsViewModel.copyToClipboard, type: .toast, position: .top, autohideIn: 2) {
            VStack(alignment: .center) {
               Spacer()
                  .frame(height: UIScreen.main.bounds.height / 22)
               Label(settingsViewModel.ephemeralClipboard ? "Copied to clipboard (60sec)" : "Copied to clipboard", systemImage: settingsViewModel.ephemeralClipboard ? "timer" : "checkmark.circle")
                  .padding(14)
                  .foregroundColor(Color.white)
                  .background(Color.accentColor)
                  .cornerRadius(30)
            }
         }
      }
      .onTapGesture {
         dismissKeyboard()
      }
   }
   
   private func dismissKeyboard() {
      UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
   }
   
   
}

struct NotesView_Previews: PreviewProvider {
   static var previews: some View {
      NotesView(settingsViewModel: SettingsViewModel())
   }
}
