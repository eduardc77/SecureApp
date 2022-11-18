//
//  OnboardingCell.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import SwiftUI

struct OnboardingCell: View {
   let image: String
   let text: LocalizedStringKey
   let title: LocalizedStringKey
   
   var body: some View {
      
      HStack {
         ZStack {
            Circle()
               .foregroundColor(.accentColor)
               .frame(minWidth: 50, maxWidth: 60, minHeight: 50, maxHeight: 60)
            
            Image(systemName: image)
               .frame(minWidth: 50, maxWidth: 60, minHeight: 50, maxHeight: 60)
               .font(.largeTitle)
               .foregroundColor(.white)
         }
         VStack(alignment: .leading) {
            Text(title).bold()
            
            Spacer()
               .frame(height: 5)
            
            Text(text)
               .font(.body)
               .foregroundColor(.gray)
         }
         .padding()
      }
   }
}

struct OnboardingCell_Previews: PreviewProvider {
   static var previews: some View {
      OnboardingCell(image: "key.viewfinder", text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", title: "Sécurisé")
   }
}
