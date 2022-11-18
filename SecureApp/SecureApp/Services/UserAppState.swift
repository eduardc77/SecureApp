//
//  Authentication.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import Foundation

enum AppStatus: Comparable {
   case loggedOut
   case authenticating
   case authenticated
   case authorizing
   case authorized
}

class UserAppState: ObservableObject {
   @Published var currentStatus: AppStatus = .loggedOut
   
   static func login(credentials: Credentials,
                     completion: @escaping (Result<Bool,AuthenticationError>) -> Void) async {
      try? await Task.sleep(nanoseconds:  1_000_000_000)
      
      if credentials.password == "password" {
         completion(.success(true))
      } else {
         completion(.failure(.invalidCredentials))
      }
      
   }
   
   func updateAppStatus(with currentStatus: AppStatus) {
      self.currentStatus = currentStatus
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
