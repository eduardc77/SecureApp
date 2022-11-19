//
//  LoginView.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import SwiftUI

struct LoginView: View {
   @EnvironmentObject private var keychainService: KeychainService
   @StateObject var viewModel: LoginViewModel
   @EnvironmentObject private var authentication: UserAppState
   @State var isLoading: Bool = false
   
   var body: some View {
      VStack(spacing: 6) {
         EntryField(text: $viewModel.credentials.email, systemName: "envelope", placeholder: "Email Address")
         
         EntryField(text: $viewModel.credentials.password, systemName: "lock", placeholder: "Password", isSecure: true)
         
         Button {
               dismissKeyboard()
            
            Task {
               await viewModel.login { success in
                  guard success else { return }
                  print("Successful Login")
               }
            }
         } label: {
            Text("Log in")
               .frame(maxWidth: .infinity, maxHeight: 36)
               .foregroundColor(.white)
               .background(Color.accentColor)
               .cornerRadius(6)
               .contentShape(Rectangle())
         }
         .disabled(viewModel.loginDisabled)
         
         if KeychainService.biometricType != .none {
            Button {
               dismissKeyboard()
               authentication.updateAuthState(with: .authenticating)
               
               keychainService.biometricAuthentication { (result: Result<Credentials, AuthenticationError>) in
                  switch result {
                     case .success(let credentials):
                        viewModel.credentials = credentials
                        
                        Task {
                           await viewModel.login()
                        }
                     case .failure(let error):
                        viewModel.error = error
                        authentication.updateAuthState(with: .loggedOut)
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
      
      .padding(30)
      .background(Color(.tertiarySystemBackground))
      .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
      .shadow(radius: 10, x: -1, y: 1)
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
      LoginView(viewModel: LoginViewModel(authentication: UserAppState()))
         .environmentObject(UserAppState())
   }
}
