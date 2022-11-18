//
//  Authentication.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import Foundation

class UserAppState: ObservableObject {
   @Published var authState: AuthState = .loggedOut
   
   static func login(credentials: Credentials,
                     completion: @escaping (Result<Bool,AuthenticationError>) -> Void) async {
      
      do {
         try await Task.sleep(nanoseconds:  2_000_000_000)
         
         DispatchQueue.main.async {
            if credentials.password == "password" {
               completion(.success(true))
               
            } else {
               completion(.failure(.invalidCredentials))
            }
         }
      } catch {
         completion(.failure(.deniedAccess))
      }
   }
   
   func updateAppStatus(with authState: AuthState) {
      self.authState = authState
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
