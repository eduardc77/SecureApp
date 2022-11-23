//
//  WelcomeItemModel.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 20.11.2022.
//

import Foundation

struct WelcomeItemModel: Hashable {
	var title: String
	var description: String
	var imageName: String
	
	static var welcomeItems = [
		[
			WelcomeItemModel(title: "Secure", description: "Lorem ipsum dolor sit amet, dolor, dolor adipiscing elit.", imageName: "lock.shield.fill"),
			WelcomeItemModel(title: "Safe", description: "Lorem ipsum dolor sit amet, ipsum adipiscing elit, elit adipiscing elit.", imageName: "key.horizontal"),
			WelcomeItemModel(title: "Biometrics", description: "\(String.adaptiveBiometricDescription), dolor adipiscing elit", imageName: String.adaptiveBiometricImage)
		],
		
		[
			WelcomeItemModel(title: "Secure", description: "Lorem ipsum dolor, consectetur adipiscing elit.", imageName: "person.badge.key"),
			WelcomeItemModel(title: "Unlock", description: "Lorem ipsum dolor sit amet, ipsum adipiscing elit Lorem ipsum dolor sit amet.", imageName: "lock.open.iphone"),
			WelcomeItemModel(title: "Biometrics", description: String.adaptiveBiometricDescription, imageName: String.adaptiveBiometricImage)
		],
		
		[
			WelcomeItemModel(title: "Safety", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", imageName: "key.viewfinder"),
			WelcomeItemModel(title: "Security", description: "Lorem ipsum dolor sit, consectetur adipiscing elit Lorem ipsum dolor sit amet.", imageName: "lock.square"),
			WelcomeItemModel(title: "Biometrics", description: String.adaptiveBiometricDescription, imageName: String.adaptiveBiometricImage)
		]
	]
}
