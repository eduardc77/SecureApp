//
//  PrivacyView.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import SwiftUI

struct PrivacyView: View {
   var body: some View {
      ZStack {
         Color.accentColor.ignoresSafeArea()
         
         Image(systemName: "eye.slash")
            .foregroundColor(.white)
            .font(.system(size: 60))
      }
   }
}

struct PrivacyView_Previews: PreviewProvider {
   static var previews: some View {
      PrivacyView()
   }
}
