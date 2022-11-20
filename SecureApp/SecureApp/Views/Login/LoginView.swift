//
//  LoginView.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import SwiftUI

struct LoginView: View {
   @StateObject var viewModel: LoginViewModel
   @EnvironmentObject private var appState: UserAppState
   @State var isLoading: Bool = false
   
	var body: some View {
		ZStack {
			Color(.systemGroupedBackground).ignoresSafeArea()

			VStack(spacing: 16) {
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
						.frame(maxWidth: .infinity, maxHeight: 40)
						.foregroundColor(.white)
						.font(.body.weight(.medium))
				}
				.buttonStyle(.mainButtonStyle())
				.disabled(viewModel.loginDisabled)

				if UserAppState.biometricType != .none {
					Button {
						UIApplication.shared.endEditing()
						appState.updateAuthState(with: .authenticating)

						appState.biometricAuthentication { (result: Result<Credentials, AuthenticationError>) in
							switch result {
							case .success(let credentials):
								viewModel.credentials = credentials
                        
								Task {
									await viewModel.login()
								}
							case .failure(let error):
								viewModel.error = error
								appState.updateAuthState(with: .loggedOut)
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
			.background(Color(.secondarySystemGroupedBackground))
			.clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
			.shadow(color: Color(white: 0, opacity: 0.16), radius: 16, x: 8, y: 8)
			.padding(24)

			.alert(item: $viewModel.error) { error in
				if error == .credentialsNotSaved {
					return Alert(title: Text("Credentials Not Saved"),
											 message: Text(error.localizedDescription),
											 primaryButton: .default(Text("OK"), action: {
						viewModel.storeCredentialsNext = true
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

			.toast(isPresenting: $isLoading) {
				AlertToast(displayMode: .alert, type: .loading, title: appState.state.title)
			}
		}
	}
}


struct LoginView_Previews: PreviewProvider {
   static var previews: some View {
		LoginView(viewModel: LoginViewModel(appState: UserAppState(authService: AuthService())))
			.environmentObject(UserAppState(authService: AuthService()))
   }
}
