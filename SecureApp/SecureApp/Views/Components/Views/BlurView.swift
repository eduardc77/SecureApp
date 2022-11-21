//
//  BlurView.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 21.11.2022.
//

import SwiftUI

struct BlurView: UIViewRepresentable {
	func makeUIView(context: Context) -> UIVisualEffectView {
		let blurEffect = UIBlurEffect(style: .dark)
		let blurView =  UIVisualEffectView(effect: blurEffect)
		return blurView
	}
	
	func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}
