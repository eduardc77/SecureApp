//
//  AuthenticationView.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import SwiftUI

struct AuthenticationView: View {
   @EnvironmentObject var authentication: Authentication
   @State private var scale: CGFloat = 1
   @ObservedObject var viewModel: SettingsViewModel
   @State var biometricType: SettingsViewModel.BiometricType
   @ObservedObject var settingsViewModel: SettingsViewModel
   @State private var animate = false
   
   var body: some View {
      NavigationView {
         ZStack {
            settingsViewModel.colors[settingsViewModel.accentColorIndex]
               .ignoresSafeArea()
            
            VStack {
               Image(systemName: "lock.fill")
                  .resizable()
                  .scaledToFit()
                  .frame(maxWidth: 100, maxHeight: 100)
                  .foregroundColor(.white)
                  .font(.system(size: 80))
                  .scaleEffect(scale)
                  .animateForever { scale = 0.90 }
                  .padding()
               
               Spacer()
               
               // MARK: - Login
               VStack {
                  Button(action: {
                     if viewModel.biometricAuthentication() {}
                  },
                         label: {
                     Label(
                        title: { biometricType == .face ? Text("Unlock with Face ID") : biometricType == .touch ? Text("Unlock with Touch ID") : Text("Enter device passcode") },
                        icon: { Image(systemName: adaptiveImage(biometricType: biometricType)) }
                     )})
                  .foregroundColor(.white)
                  .padding()
                  .overlay(Capsule().stroke(Color.white, lineWidth: 1))
               }
               .padding()
            }
            
            .onAppear(perform: {
               biometricType = viewModel.biometricType()
               
               if settingsViewModel.unlockMethodIsActive == false {
                  settingsViewModel.isUnlocked = true
                  print("No biometric authentication")
               }
               
               if settingsViewModel.unlockMethodIsActive == true {
                  if settingsViewModel.biometricAuthentication() {
                  }
                  print("Biometric authentication")
               }
            })
            
         }
         .transition(.identity)
         
         .toolbar {
            Button {
               authentication.updateValidation(success: false)
            } label: {
               Text("Logout")
                  .foregroundColor(.white)
            }
         }
      }
   }
}

struct LoggingView_Previews: PreviewProvider {
   static var previews: some View {
      AuthenticationView(viewModel: SettingsViewModel(), biometricType: SettingsViewModel.BiometricType.touch, settingsViewModel: SettingsViewModel())
   }
}
