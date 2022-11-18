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
   var disabled: Bool = false
   
  func makeBody(configuration: Configuration) -> some View {
     let currentForegroundColor = disabled || configuration.isPressed ? foregroundColor.opacity(0.6) : foregroundColor
     let currentBackgroundColor = disabled  ? .secondary.opacity(0.6) : configuration.isPressed ? backgroundColor.opacity(0.6) : backgroundColor
     
    HStack {
      Spacer()
      configuration.label.foregroundColor(currentForegroundColor)
      Spacer()
    }
    .padding()
    .background(currentBackgroundColor.cornerRadius(8))
    .buttonStyle(.plain)
    .contentShape(Rectangle())
    .disabled(disabled)
  }
}

extension ButtonStyle where Self == RoundedRectangleButtonStyle {
   static var mainButtonStyle: RoundedRectangleButtonStyle { .init() }
   
   static func mainButtonStyle(foregroundColor: Color = .white, backgroundColor: Color = .accentColor, disabled: Bool = false) -> RoundedRectangleButtonStyle {
      RoundedRectangleButtonStyle(foregroundColor: foregroundColor, backgroundColor: backgroundColor, disabled: disabled)
   }
   
   static func plainButtonStyle(foregroundColor: Color = .accentColor, backgroundColor: Color = .clear, disabled: Bool = false) -> RoundedRectangleButtonStyle {
      RoundedRectangleButtonStyle(foregroundColor: foregroundColor, backgroundColor: backgroundColor, disabled: disabled)
   }
}
