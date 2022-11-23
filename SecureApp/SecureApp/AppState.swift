//
//  Authentication.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import SwiftUI
import LocalAuthentication
import Combine

class AppState: ObservableObject {
	// MARK: - Properties
	
	@Published var state: AuthState = .loggedOut
	@Published var appLocked = false
	@Published var lockAppTimerIsRunning = false
	@Published var welcomeSheetIsPresented = false
	
	@AppStorage("autoLockIndex") var autoLockIndex: Int = 0
	@AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true
	
	let authService: AuthService
	
	// MARK: - Initialization
	
	init(authService: AuthService) {
		self.authService = authService
		updateCurrentState()
	}
	
	// MARK: - Private Methods
	
	private func updateCurrentState() {
		authService.authStatePublisher
			.receive(on: RunLoop.main)
			.assign(to: &$state)
	}
	
	// MARK: - Public Methods
	
	func login(credentials: Credentials, completion: ((Result<Bool, AuthenticationError>) -> Void)? = nil) async {
		await authService.login(credentials: credentials) { (result: Result<Bool, AuthenticationError>) in
			switch result {
			case .success:
				completion?(.success(true))
				
			case .failure(let authError):
				completion?(.failure(authError))
			}
		}
	}
	
	// MARK: - Biometric Authentication
	
	static var biometricType: BiometricType {
		let authContext = LAContext()
		authContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)

		switch authContext.biometryType {
		case .none:
			return .none
		case .touchID:
			return .touch
		case .faceID:
			return .face
		@unknown default:
			return .unknown
		}
	}
	
	func biometricAuthentication(completion: ((Result<Credentials, AuthenticationError>) -> Void)? = nil) {
		let credentials = KeychainService.getCredentials()
		
		guard let credentials = credentials else {
			completion?(.failure(.credentialsNotSaved))
			return
		}
		
		let context = LAContext()
		var error: NSError?
		let reason = "Required for logging in to the app."
		
		if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
			if let error = error {
				switch error.code {
				case -6:
					completion?(.failure(.deniedAccess))
				case -7:
					completion?(.failure(.noBiometricEnrolled))
				default:
					completion?(.failure(.biometricError))
				}
				
				return
			}
			
			context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, error in
				DispatchQueue.main.async {
					if success {
						print("Success")
						self.appLocked = false
						completion?(.success(credentials))
					} else {
						self.appLocked = true
						print("Failed to authenticate using Biometrics.")
						completion?(.failure(.biometricError))
					}
				}
			}
		} else {
			print("No Device Owner Authentication")
		}
	}
	
	// MARK: - App Lock
	
	func lockAppInBackground() {
		lockAppTimerIsRunning = true
		let seconds: Int = 1 + autoLockIndex * 60
		let dispatchAfter = DispatchTimeInterval.seconds(seconds)
		
		DispatchQueue.main.asyncAfter(deadline: .now() + dispatchAfter) {
			if self.lockAppTimerIsRunning {
				self.appLocked = true
				self.lockAppTimerIsRunning = false
			}
		}
	}
}

enum BiometricType {
	case none
	case face
	case touch
	case unknown
}
