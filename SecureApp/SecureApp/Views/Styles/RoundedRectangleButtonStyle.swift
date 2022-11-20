//
//  RoundedRectangleButtonStyle.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 18.11.2022.
//

import SwiftUI

struct RoundedRectangleButtonStyle: ButtonStyle {
   var foregroundColor: Color = .white
   var backgroundColor: Color = .accentColor
   
  func makeBody(configuration: Configuration) -> some View {
     let currentForegroundColor = configuration.isPressed ? foregroundColor.opacity(0.3) : foregroundColor
     let currentBackgroundColor = configuration.isPressed ? backgroundColor.opacity(0.3) : backgroundColor

    HStack {
      Spacer()
			configuration.label.foregroundColor(currentForegroundColor)
      Spacer()
    }

    .background(currentBackgroundColor.cornerRadius(8))
    .buttonStyle(.plain)
    .contentShape(Rectangle())
  }
}

extension ButtonStyle where Self == RoundedRectangleButtonStyle {
   static var mainButtonStyle: RoundedRectangleButtonStyle { .init() }
   
   static func mainButtonStyle(foregroundColor: Color = .white, backgroundColor: Color = .accentColor) -> RoundedRectangleButtonStyle {
      RoundedRectangleButtonStyle(foregroundColor: foregroundColor, backgroundColor: backgroundColor)
   }
   
   static func plainButtonStyle(foregroundColor: Color = .accentColor) -> RoundedRectangleButtonStyle {
		 RoundedRectangleButtonStyle(foregroundColor: foregroundColor, backgroundColor: .clear)
   }
}
