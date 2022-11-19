//
//  Authentication.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import Foundation

class UserAppState: ObservableObject {
   @Published private(set) var authState: AuthState = .loggedOut
   
   func login(credentials: Credentials,
              completion: @escaping (Result<Bool,AuthenticationError>) -> Void) async {
      updateAuthState(with: .authenticating)
      
      do {
         try await Task.sleep(nanoseconds:  2_000_000_000)

         if credentials.password == "password" {
            DispatchQueue.main.async { [self] in
               updateAuthState(with: .authorizing)
            }
            
            try await Task.sleep(nanoseconds:  2_600_000_000)
            
            DispatchQueue.main.async { [self] in
               completion(.success(true))
               self.updateAuthState(with: .authorized)
            }
            
         } else {
            DispatchQueue.main.async { [self] in
               completion(.failure(.invalidCredentials))
               self.updateAuthState(with: .loggedOut)
            }
         }
         
      } catch {
         completion(.failure(.deniedAccess))
         authState = .loggedOut
      }
   }
   
   func updateAuthState(with authState: AuthState) {
      DispatchQueue.main.async {
         self.authState = authState
      }
   }
}

enum AuthState: Comparable {
   case loggedOut
   case authenticating
   case authenticated
   case authorizing
   case authorized
   
   var isLoading: Bool {
      return self == .authenticating || self == .authorizing
   }
   
   var title: String {
      switch self {
         case .loggedOut:
            return "Logged Out"
         case .authenticating:
            return "Authenticating…"
         case .authenticated:
            return "Authenticated"
         case .authorizing:
            return "Authorizing…"
         case .authorized:
            return "Authorized"
      }
   }
}


enum AuthenticationError: Error, LocalizedError, Identifiable {
   case invalidCredentials
   case deniedAccess
   case noBiometricEnrolled
   case biometricError
   case credentialsNotSaved
   
   var id: String {
      self.localizedDescription
   }
   
   var errorDescription: String? {
      switch self {
         case .invalidCredentials:
            return NSLocalizedString("Either your email or password are incorrect. Please try again.", comment: "")
         case .deniedAccess:
            return NSLocalizedString("You have denied access. Please go to the settings app and locate this application and turn \(String.adaptiveBiometricTitle) on.", comment: "")
         case .noBiometricEnrolled:
            return NSLocalizedString("You have not registered any \(String.adaptiveBiometricTitle)s yet", comment: "")
         case .biometricError:
            return NSLocalizedString("Your \(String.adaptiveBiometricTitle) was not recognized.", comment: "")
         case .credentialsNotSaved:
            return NSLocalizedString("Your credentials have not been saved. Do you want to save them after the next successful login?", comment: "")
      }
   }
}
