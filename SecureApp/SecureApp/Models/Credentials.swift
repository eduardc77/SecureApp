//
//  Credentials.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import Foundation

struct Credentials: Codable {
	var email: String = ""
	var password: String = ""
	
	func encoded() -> String {
		let encoder = JSONEncoder()
		var credentialsData: Data = Data()
		
		do {
			credentialsData = try encoder.encode(self)
		} catch {
			print(error)
		}
		guard let string = String(data: credentialsData, encoding: .utf8) else {
			print("Could not encode credentials")
			return ""
		}
		
		return string
	}
	
	static func decode(_ credentialsString: String) -> Credentials {
		let decoder = JSONDecoder()
		var decodedCredentials: Credentials = Credentials()
		
		guard let jsonData = credentialsString.data(using: .utf8) else {
			print("Could not decode credentials")
			return decodedCredentials
		}
		
		do {
			decodedCredentials = try decoder.decode((Credentials.self), from: jsonData)
		} catch {
			print(error.localizedDescription)
		}
		
		return decodedCredentials
	}
}
