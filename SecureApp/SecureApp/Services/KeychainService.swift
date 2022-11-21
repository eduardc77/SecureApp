//
//  KeychainService.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import SwiftUI
import SwiftKeychainWrapper

final class KeychainService: ObservableObject {
	static let credentialsStorageKey = "credentials"
	
	static func getCredentials() -> Credentials? {
		guard let myCredentialsString = KeychainWrapper.standard.string(forKey: credentialsStorageKey) else { return nil }
		
		return Credentials.decode(myCredentialsString)
	}
	
	static func saveCredentials(_ credentials: Credentials) -> Bool {
		guard KeychainWrapper.standard.set(credentials.encoded(), forKey: Self.credentialsStorageKey) else { return false }
		
		return true
	}
}
