//
//  AuthService.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 20.11.2022.
//

import Foundation
import Combine

class AuthService: ObservableObject {
	// MARK: - Properties
	
	@Published private(set) var authState = CurrentValueSubject<AuthState, Never>(.loggedOut)
	
	var authStatePublisher: AnyPublisher<AuthState, Never> {
		authState.eraseToAnyPublisher()
	}
	
	// MARK: - Public Methods
	
	func login(credentials: Credentials, completion: ((Result<Bool, AuthenticationError>) -> Void)? = nil) async {
		authState.send(.authenticating)
		
		do {
			try await Task.sleep(nanoseconds:  2_000_000_000)
			
			if credentials.password == "password" {
				authState.send(.authorizing)
				try await Task.sleep(nanoseconds:  2_600_000_000)
				authState.send(.authorized)
				completion?(.success(true))
			} else {
				authState.send(.loggedOut)
				completion?(.failure(.invalidCredentials))
			}
		} catch {
			completion?(.failure(.deniedAccess))
			authState.send(.loggedOut)
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
			return NSLocalizedString("You have denied access. Please go to the settings app, locate this application and turn \(String.adaptiveBiometricTitle) on.", comment: "")
		case .noBiometricEnrolled:
			return NSLocalizedString("You have not registered any \(String.adaptiveBiometricTitle)s yet", comment: "")
		case .biometricError:
			return NSLocalizedString("Your \(String.adaptiveBiometricTitle) was not recognized.", comment: "")
		case .credentialsNotSaved:
			return NSLocalizedString("Your credentials have not been saved. Do you want to save them after the next successful login?", comment: "")
		}
	}
}
