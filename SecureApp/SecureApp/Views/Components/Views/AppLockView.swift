//
//  AppLockView.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import SwiftUI

struct AppLockView: View {
   @EnvironmentObject var appState: UserAppState
	@ObservedObject var viewModel: SettingsViewModel

   @State private var scale: CGFloat = 1
   @State private var animate = false

   
   var body: some View {
      NavigationView {
         ZStack {
            viewModel.colors[viewModel.accentColorIndex]
               .ignoresSafeArea()

            VStack {
							Image(systemName: appState.appLocked ? "lock.fill" : "lock.open.fill")
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
							appState.biometricAuthentication()
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

         .onAppear {
            if viewModel.biometricUnlockIsActive {
					appState.biometricAuthentication()
            } else {
					appState.appLocked = false
            }
         }
         
         .toolbar {
            Button {
               DispatchQueue.main.async {
						appState.updateAuthState(with: .loggedOut)
						appState.appLocked = false
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
			.environmentObject(UserAppState(authService: AuthService()))
			 .environmentObject(KeychainService())
   }
}
