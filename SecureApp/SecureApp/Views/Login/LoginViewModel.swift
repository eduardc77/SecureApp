//
//  LoginViewModel.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import Foundation

class LoginViewModel: ObservableObject {
	@Published var appState: UserAppState
	@Published var credentials = Credentials()
	@Published var error: AuthenticationError?
	
	init(appState: UserAppState) {
		self.appState = appState
	}
	
	var loginDisabled: Bool {
		credentials.email.isEmpty || credentials.password.isEmpty || appState.state.isLoading
	}
	
	func login(completion: ((Bool) -> Void)? = nil) async {
		await appState.login(credentials: credentials) { [unowned self] (result: Result<Bool, AuthenticationError>) in
			
			switch result {
			case .success:
				storeCredentials()
				completion?(true)
			case .failure(let authError):
				DispatchQueue.main.async {
					self.error = authError
				}
				
				completion?(false)
			}
		}
	}
	
	func storeCredentials() {
		guard let storedCredentials = KeychainService.getCredentials() else {
			_ = KeychainService.saveCredentials(credentials)
			return
		}
		
		if storedCredentials.email != credentials.email || storedCredentials.password != credentials.password {
			_ = KeychainService.saveCredentials(credentials)
		}
	}
	
	var emailPrompt: String {
		"Enter a valid email address"
	}
	
	var passwordPrompt: String {
		"Must be at least 8 characters containing at least one number and one letter and one special character."
	}
}
