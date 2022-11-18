//
//  BlurView.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 18.11.2022.
//

import SwiftUI

public struct BlurView: UIViewRepresentable {
   public typealias UIViewType = UIVisualEffectView
   
   public func makeUIView(context: Context) -> UIVisualEffectView {
      return UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
   }
   
   public func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
      uiView.effect = UIBlurEffect(style: .systemMaterial)
   }
}
