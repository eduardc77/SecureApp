//
//  AuthenticationView.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import SwiftUI

struct AuthenticationView: View {
   @State private var scale: CGFloat = 1
   @ObservedObject var viewModel: SettingsViewModel
   @State var biometricType: SettingsViewModel.BiometricType
   @ObservedObject var settingsViewModel: SettingsViewModel
   @State private var animate = false
   
   var body: some View {
      
      ZStack {
         settingsViewModel.colors[settingsViewModel.accentColorIndex].ignoresSafeArea()
         
         VStack {
            Image(systemName: "lock.fill")
               .resizable()
               .scaledToFit()
               .frame(minWidth: 10, idealWidth: 50, maxWidth: 100, minHeight: 0, idealHeight: 50, maxHeight: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
               .foregroundColor(.white)
               .font(.system(size: 80))
               .scaleEffect(scale)
               .animateForever { scale = 0.90 }
               .padding(60)
            
            Spacer()
            
            Button(action: {
               if viewModel.biometricAuthentication() {
                  // MARK: - Login
               }
               
            },
                   label: {
               Label(
                  title: { biometricType == .face ? Text("Unlock with Face ID") : biometricType == .touch ? Text("Unlock with Touch ID") : Text("Enter device passcode") },
                  icon: { Image(systemName: adaptiveImage(biometricType: biometricType)) }
               )})
            .foregroundColor(.white)
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 25)
               .stroke(Color.white, lineWidth: 1))
            
         }
         
         .onAppear(perform: {
            biometricType = viewModel.biometricType()
            
            if settingsViewModel.unlockMethodIsActive == false {
               settingsViewModel.isUnlocked = true
               print("No biometric authentication")
            }
            
            if settingsViewModel.unlockMethodIsActive == true {
               if settingsViewModel.biometricAuthentication() {
               }
               print("Biometric authentication")
            }
         })
         
      }
      .statusBar(hidden: true)
      .transition(.identity)
   }
}

struct LoggingView_Previews: PreviewProvider {
   static var previews: some View {
      AuthenticationView(viewModel: SettingsViewModel(), biometricType: SettingsViewModel.BiometricType.touch, settingsViewModel: SettingsViewModel())
   }
}
