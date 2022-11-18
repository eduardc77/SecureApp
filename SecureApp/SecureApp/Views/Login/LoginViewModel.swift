//
//  LoginViewModel.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var credentials = Credentials()
    @Published var error: AuthenticationError?
    @Published var storeCredentialsNext = false
    
    var loginDisabled: Bool {
        credentials.email.isEmpty || credentials.password.isEmpty
    }
    
   func login(completion: @escaping (Bool) -> Void) async {
       
      await UserAppState.login(credentials: credentials) { [unowned self](result:Result<Bool, AuthenticationError>) in
           
            switch result {
            case .success:
                if storeCredentialsNext {
                    if KeychainService.saveCredentials(credentials) {
                        storeCredentialsNext = false
                    }
                }
                completion(true)
            case .failure(let authError):
                  DispatchQueue.main.async {
                     self.credentials = Credentials()
                     self.error = authError
                     completion(false)
                  }
            }
        }
    }
   
   var emailPrompt: String {

           "Enter a valid email address"
   }
   
   var passwordPrompt: String {

           "Must be at least 8 characters containing at least one number and one letter and one special character."
   }
}
