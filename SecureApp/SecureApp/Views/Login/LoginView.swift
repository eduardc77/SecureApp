//
//  LoginView.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import SwiftUI

struct LoginView: View {
	@EnvironmentObject private var appState: AppState
	@StateObject var viewModel: LoginViewModel
	@StateObject var settingsViewModel: SettingsViewModel
	@State private var isLoading: Bool = false
	
	var body: some View {
		VStack {
			Spacer()
			
			VStack(spacing: 20) {
				EntryField(text: $viewModel.credentials.email, systemName: "envelope", placeholder: "Email Address")
				
				EntryField(text: $viewModel.credentials.password, systemName: "lock", placeholder: "Password", isSecure: true)
				
				Button {
					UIApplication.shared.endEditing()
					
					Task {
						await viewModel.login { success in
							guard success else { return }
							print("Successful Login")
						}
					}
				} label: {
					Text("Log in")
				}
				.buttonStyle(.mainButtonStyle())
				.disabled(viewModel.loginDisabled)
				
				if AppState.biometricType != .none || AppState.biometricType != .unknown {
					Button {
						UIApplication.shared.endEditing()
						
						appState.biometricAuthentication { (result: Result<Credentials, AuthenticationError>) in
							switch result {
							case .success(let credentials):
								viewModel.credentials = credentials
								settingsViewModel.biometricUnlockIsActive = true
								Task {
									await viewModel.login()
								}
							case .failure(let error):
								viewModel.error = error
							}
						}
					} label: {
						Image(systemName: String.adaptiveBiometricImage)
							.resizable()
							.font(.body.weight(.light))
							.frame(width: 40, height: 40)
					}

					.frame(maxWidth: .infinity)
					.buttonStyle(.plainButtonStyle())
				}
			}
			
			.padding(32)
			.background(Color.secondaryGroupedBackground)
			.clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
			.shadow(color: Color(white: 0, opacity: 0.16), radius: 16, x: 8, y: 8)
			.padding(24)
			
			.alert(item: $viewModel.error) { error in
				if error == .credentialsNotSaved {
					return Alert(title: Text("Credentials Not Saved"),
									 message: Text(error.localizedDescription),
									 primaryButton: .default(Text("OK"), action: {
					}),
									 secondaryButton: .cancel())
				} else {
					return Alert(title: Text("Invalid Login"), message: Text(error.localizedDescription))
				}
			}
			
			.onAppear {
				if let credentials = KeychainService.getCredentials() {
					viewModel.credentials = credentials
				}
			}
			.onChange(of: appState.state) { status in
				isLoading = status.isLoading ? true : false
			}
			
			Spacer()
		}
		.background(Color.groupedBackground.ignoresSafeArea())
		
		.popup(isPresenting: $isLoading) {
			PopupView(displayMode: .alert, type: .loading, title: appState.state.title)
		}
	}
}


// MARK: - Previews

struct LoginView_Previews: PreviewProvider {
	static var previews: some View {
		LoginView(viewModel: LoginViewModel(appState: AppState(authService: AuthService())), settingsViewModel: SettingsViewModel())
			.environmentObject(AppState(authService: AuthService()))
	}
}
