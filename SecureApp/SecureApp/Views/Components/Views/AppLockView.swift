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
							Image(systemName: keychainService.appLocked ? "lock.fill" : "lock.open.fill")
                  .resizable()
                  .scaledToFit()
                  .frame(maxWidth: 100, maxHeight: 100)
                  .foregroundColor(.white)
                  .font(.system(size: 80))
                  .scaleEffect(scale)
                  .animateForever { scale = 0.90 }
                  .padding()

               Spacer()
               
               VStack {
                  Button(action: {
                     keychainService.biometricAuthentication()
                  }, label: {
                     
                     Label(
                        title: { Text(String.adaptiveBiometricMessage) },
												icon: { Image(systemName: String.adaptiveBiometricImage).font(.title2) }
                     )})
                  
                  .foregroundColor(.white)
                  .padding()
                  .overlay(Capsule().stroke(Color.white, lineWidth: 1))
               }
               .padding()
            }
         }
         .transition(.identity)
         
         .onAppear {
            if keychainService.biometricUnlockIsActive {
               keychainService.biometricAuthentication()
            } else {
               keychainService.appLocked = false
            }
         }
         
         .toolbar {
            Button {
               DispatchQueue.main.async {
                  authentication.updateAuthState(with: .loggedOut)
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
			 .environmentObject(UserAppState())
			 .environmentObject(KeychainService())
   }
}
