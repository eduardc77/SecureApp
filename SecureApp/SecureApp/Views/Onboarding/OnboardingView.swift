//
//  OnboardingView.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import SwiftUI

struct OnboardingView: View {
   @EnvironmentObject private var appState: UserAppState
   @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
   @Environment(\.colorScheme) private var colorScheme
   
   var body: some View {
      
      VStack {
         Spacer()
         
         Text("Welcome to Secure App")
            .font(.title)
            .bold()
         
         Spacer()
         
         VStack(alignment: .leading) {
            OnboardingCell(image: "key.viewfinder",
                           text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                           title: "Secure")
            .padding()
            
            OnboardingCell(image: "lock.square",
                           text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                           title: "Safe")
            .padding()
            
            OnboardingCell(image: String.adaptiveBiometricImage,
                           text:  LocalizedStringKey(String.adaptiveBiometricDescription),
                           title: "Biometrics")
            .padding()
            
         }
         .padding()
         
         Spacer()
         
         Button(action: {
            presentationMode.wrappedValue.dismiss()
            appState.isFirstLaunch = false
         },
                label: {
            HStack {
               Spacer().frame(maxWidth: 100)
               
               Text("Continue")
                  .foregroundColor(.white)
               
               Spacer().frame(maxWidth: 100)
            }})
         .padding()
         .background(Color.accentColor)
         .cornerRadius(10)
         
         Spacer()
      }
      .environment(\.colorScheme, colorScheme)
      .font(.body)
   }
}

struct OnboardingView_Previews: PreviewProvider {
   static var previews: some View {
      OnboardingView()
         .environmentObject(KeychainService())
   }
}
