//
//  Animations.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 19.11.2022.
//

import SwiftUI

extension View {
	func animateForever(using animation: Animation = Animation.easeInOut(duration: 1.6), autoreverses: Bool = true, _ action: @escaping () -> Void) -> some View {
		return onAppear {
			withAnimation(animation.repeatForever(autoreverses: autoreverses)) {
				action()
			}
		}
	}
}
