//
//  LoginView.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import SwiftUI

struct LoginView: View {
   @EnvironmentObject private var keychainService: KeychainService
   @StateObject private var viewModel = LoginViewModel()
   @EnvironmentObject private var authentication: UserAppState
   @State var isLoading: Bool = false
   
   var body: some View {
      VStack {
         EntryField(text: $viewModel.credentials.email, sfSymbolName: "envelope", placeholder: "Email Address")
         
         EntryField(text: $viewModel.credentials.password, sfSymbolName: "lock", placeholder: "Password", isSecure: true)
         
         Button {
            authentication.updateAppStatus(with: .authenticating)
            
            Task {
               await viewModel.login { success in
                  guard success else { return }
                  DispatchQueue.main.async {
                     self.dismissKeyboard()
                     authentication.updateAppStatus(with: .authorized)
                  }
               }
            }
         } label: {
            Text("Log in")
               .frame(maxWidth: .infinity, maxHeight: 36)
               .foregroundColor(.white)
               .background(Color.accentColor)
               .cornerRadius(7)
               .contentShape(Rectangle())
         }
         .disabled(viewModel.loginDisabled)
         
         if KeychainService.biometricType != .none {
            Button {
               authentication.updateAppStatus(with: .authenticating)
               keychainService.requestBiometricUnlock { (result: Result<Credentials, AuthenticationError>) in
                  switch result {
                     case .success(let credentials):
                        viewModel.credentials = credentials
                        
                        Task {
                           await viewModel.login { success in
                              authentication.updateAppStatus(with: .authorized)
                              keychainService.biometricUnlockIsActive = true
                           }
                        }
                     case .failure(let error):
                        viewModel.error = error
                        authentication.updateAppStatus(with: .loggedOut)
                  }
               }
            } label: {
               Image(systemName: String.adaptiveBiometricImage)
                  .resizable()
                  .frame(width: 36, height: 36)
            }
            .frame(maxWidth: .infinity)
            .buttonStyle(.plainButtonStyle())
         }
      }
      .padding(36)
      .background(Color(.tertiarySystemBackground))
      .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
      .shadow(radius: 16, x: 0, y: 6)
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
      
      .onAppear {
         if let credentials = KeychainService.getCredentials() {
            viewModel.credentials = credentials
         }
      }
      .onChange(of: authentication.authState) { status in
         isLoading = status.isLoading ? true : false
      }
      
      .toast(isPresenting: $isLoading) {
         AlertToast(displayMode: .alert, type: .loading, title: authentication.authState.title)
      }
   }
}


struct LoginView_Previews: PreviewProvider {
   static var previews: some View {
      LoginView()
         .environmentObject(UserAppState())
   }
}
