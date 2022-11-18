//
//  AppLockView.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import SwiftUI

struct AppLockView: View {
   @EnvironmentObject var authentication: UserAppState
   @EnvironmentObject var keychainService: KeychainService
   @State private var scale: CGFloat = 1
   @ObservedObject var viewModel: SettingsViewModel
   @State private var animate = false
   
   var body: some View {
      NavigationView {
         ZStack {
            viewModel.colors[viewModel.accentColorIndex]
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
                     keychainService.requestBiometricUnlock { (result: Result<Credentials, AuthenticationError>) in
                        switch result {
                           case .success:
                              authentication.authState = .authorized
                              keychainService.appLocked = false
                           case .failure:
                              authentication.authState = .loggedOut
                        }
                     }
                    }, label: {
                       
                     Label(
                        title: { Text(String.adaptiveBiometricMessage) },
                        icon: { Image(systemName: String.adaptiveBiometricImage) }
                     )})
                  
                  .foregroundColor(.white)
                  .padding()
                  .overlay(Capsule().stroke(Color.white, lineWidth: 1))
               }
               .padding()
            }
            
            .onAppear {
               if keychainService.biometricUnlockIsActive == false {
                  keychainService.appLocked = false
                  print("No biometric authentication")
               }
               
               if keychainService.biometricUnlockIsActive == true {
                  keychainService.requestBiometricUnlock { (result: Result<Credentials, AuthenticationError>) in
                     switch result {
                        case .success:
                           keychainService.appLocked = false
                        case .failure:
                           keychainService.appLocked = true
                     }
                  }
                  print("Biometric authentication")
               }
            }
            
         }
         .transition(.identity)
         
         .toolbar {
            Button {
               DispatchQueue.main.async {
                  authentication.updateAppStatus(with: .loggedOut)
                  keychainService.appLocked = false
               }
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
      AppLockView(viewModel: SettingsViewModel())
   }
}
