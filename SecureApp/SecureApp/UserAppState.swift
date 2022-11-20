//
//  Authentication.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import SwiftUI
import LocalAuthentication

class UserAppState: ObservableObject {
	// MARK: - Properties

	@Published private(set) var state: AuthState = .loggedOut
	@Published var appLocked = false
	@Published var lockAppTimerIsRunning = false
	@Published var onBoardingSheetIsPresented = false

	@AppStorage("autoLockIndex") var autoLockIndex: Int = 0
	@AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true

	let authService: AuthService

	init(authService: AuthService) {
		self.authService = authService
	}

	// MARK: - Public Methods

	func login(credentials: Credentials, completion: ((Result<Bool, AuthenticationError>) -> Void)? = nil) async {
		DispatchQueue.main.async {
			self.state = self.authService.authState
		}

		await authService.login(credentials: credentials) { (result: Result<Bool, AuthenticationError>) in
			switch result {
			case .success:
				DispatchQueue.main.async {
					self.state = self.authService.authState
				}

				completion?(.success(true))
			case .failure(let authError):
				DispatchQueue.main.async {
					self.state = self.authService.authState
				}

				completion?(.failure(authError))
			}
		}
	}

	func updateAuthState(with state: AuthState) {
		DispatchQueue.main.async {
			self.state = state
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
