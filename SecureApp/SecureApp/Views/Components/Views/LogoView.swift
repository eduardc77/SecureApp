//
//  LogoView.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import SwiftUI

struct LogoView: View {
	
	var body: some View {
		ZStack {
			Color.accentColor.ignoresSafeArea()
			
			Image(systemName: "lock.doc.fill")
				.foregroundColor(.white)
				.font(.system(size: 100))
		}
	}
}

struct LogoView_Previews: PreviewProvider {
	static var previews: some View {
		LogoView()
	}
}
