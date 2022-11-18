//
//  LoginView.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import SwiftUI

struct LoginView: View {
   @EnvironmentObject var keychainService: KeychainService
   @StateObject private var viewModel = LoginViewModel()
   @EnvironmentObject var authentication: UserAppState
   
   var body: some View {
      ZStack {
         Color(.systemGray6).ignoresSafeArea()
         
         VStack {
            
            EntryField(sfSymbolName: "envelope", placeholder: "Email Address", prompt: viewModel.emailPrompt, field: $viewModel.credentials.email)
            
            EntryField(sfSymbolName: "lock", placeholder: "Password", prompt: viewModel.passwordPrompt, field: $viewModel.credentials.password, isSecure: true)
            
            if authentication.currentStatus == .authenticating || authentication.currentStatus == .authorizing {
               ProgressView()
            }
            
            Button {
               Task {
                  await viewModel.login { success in
                     guard success else { return }
                     
                     DispatchQueue.main.async {
                        self.authentication.updateAppStatus(with: .authorized)
                     }
                  }
               }
            } label: {
               Text("Log in")
                  .frame(maxWidth: .infinity, maxHeight: 40)
                  .foregroundColor(.white)
                  .background(Color.accentColor)
                  .cornerRadius(7)
                  .contentShape(Rectangle())
            }
            .disabled(viewModel.loginDisabled)
            
            if KeychainService.biometricType != .none {
               Button {
                  keychainService.requestBiometricUnlock { (result: Result<Credentials, AuthenticationError>) in
                     switch result {
                        case .success(let credentials):
                           viewModel.credentials = credentials
                           Task {
                              await viewModel.login { success in
                                 DispatchQueue.main.async {
                                    self.authentication.updateAppStatus(with: .authorized)
                                 }
                              }
                           }
                        case .failure(let error):
                           viewModel.error = error
                     }
                  }
               } label: {
                  Image(systemName: String.adaptiveBiometricImage)
                     .resizable()
                     .frame(width: 50, height: 50)
               }
               .padding()
            }
         }
         .padding(36)
         .background(Color(.systemBackground))
         .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
         .shadow(radius: 16, x: -6, y: 6)
         .padding(20)
         
         .alert(item: $viewModel.error) { error in
            if error == .credentialsNotSaved {
               return Alert(title: Text("Credentials Not Saved"),
                            message: Text(error.localizedDescription),
                            primaryButton: .default(Text("OK"), action: {
                  viewModel.storeCredentialsNext = true
               }),
                            secondaryButton: .cancel())
            } else {
               return Alert(title: Text("Invalid Login"), message: Text(error.localizedDescription))
            }
         }
      }
   }
}


struct LoginView_Previews: PreviewProvider {
   static var previews: some View {
      LoginView()
         .environmentObject(UserAppState())
   }
}
