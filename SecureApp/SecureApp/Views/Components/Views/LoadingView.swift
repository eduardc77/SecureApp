//
//  LoadingView.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 18.11.2022.
//

import SwiftUI

struct LoadingView: View {
	var body: some View {
		
		ProgressView()
			.foregroundColor(.white)
			.progressViewStyle(.circular)
			.ignoresSafeArea()
	}
}

// MARK: - Previews

struct LoadingView_Previews: PreviewProvider {
	static var previews: some View {
		LoadingView()
	}
}
