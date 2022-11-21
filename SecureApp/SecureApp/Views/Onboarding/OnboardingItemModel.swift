//
//  OnboardingItemModel.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 20.11.2022.
//

import Foundation

struct OnboardingItemModel: Hashable {
	var title: String
	var description: String
	var imageName: String
	
	static var onboardingItems = [
		[
			OnboardingItemModel(title: "Secure", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", imageName: "lock.shield.fill"),
			OnboardingItemModel(title: "Safe", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", imageName: "key.horizontal"),
			OnboardingItemModel(title: "Biometrics", description: String.adaptiveBiometricDescription, imageName: String.adaptiveBiometricImage)
		],
		
		[
			OnboardingItemModel(title: "Secure", description: "Lorem ipsum dolor.", imageName: "person.badge.key"),
			OnboardingItemModel(title: "Unlock", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", imageName: "lock.open.iphone"),
			OnboardingItemModel(title: "Biometrics", description: String.adaptiveBiometricDescription, imageName: String.adaptiveBiometricImage)
		],
		
		[
			OnboardingItemModel(title: "Safety", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", imageName: "key.viewfinder"),
			OnboardingItemModel(title: "Security", description: "Lorem ipsum dolor sit.", imageName: "lock.square"),
			OnboardingItemModel(title: "Biometrics", description: String.adaptiveBiometricDescription, imageName: String.adaptiveBiometricImage)
		]
	]
}
