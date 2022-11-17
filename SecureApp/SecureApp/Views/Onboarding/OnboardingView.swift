//
//  OnboardingView.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import SwiftUI

struct OnboardingView: View {
   @ObservedObject var settingsViewModel: SettingsViewModel
   @State var biometricType: SettingsViewModel.BiometricType
   @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
   @Environment(\.colorScheme) var colorScheme
   
   var body: some View {
      
      VStack {
         Spacer()
         
         Text("Welcome to Secure App")
            .font(.title)
            .bold()
         
         Spacer()
         
         VStack(alignment: .leading) {
            OnboardingCell(image: "key.fill",
                           text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                           title: "Secure")
            .padding()
            
            OnboardingCell(image: "lock.square",
                           text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                           title: "Safe")
            .padding()
            
            OnboardingCell(image: adaptiveImage(biometricType: biometricType),
                           text: adaptiveMessage(biometricType: biometricType),
                           title: "Biometrics")
            .padding()
            
         }
         .padding()
         
         Spacer()
         
         Button(action: {
            presentationMode.wrappedValue.dismiss()
            settingsViewModel.isFirstLaunch = false
         },
                label: {
            HStack {
               Spacer().frame(maxWidth: 100)
               
               Text("Continue")
                  .foregroundColor(.white)
               
               Spacer().frame(maxWidth: 100)
            }})
         .padding()
         .background(settingsViewModel.colors[settingsViewModel.accentColorIndex])
         .cornerRadius(10)
         
         Spacer()
      }
      .environment(\.colorScheme, colorScheme)
      .font(.body)
      
      .onAppear(perform: {
         biometricType = settingsViewModel.biometricType()
      })
   }
}

struct OnboardingView_Previews: PreviewProvider {
   static var previews: some View {
      OnboardingView(settingsViewModel: SettingsViewModel(), biometricType: .touch)
   }
}
