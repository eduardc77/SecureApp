//
//  WelcomePageView.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 20.11.2022.
//

import SwiftUI

struct WelcomePageView: View {
	@State var welcomePages: [[WelcomeItemModel]]
	
	init(welcomePages: [[WelcomeItemModel]] = WelcomeItemModel.welcomeItems) {
		self.welcomePages = welcomePages
	}
	
	var body: some View {
		TabView {
			ForEach(welcomePages, id: \.self) { page in
				LazyVGrid(columns: columns, alignment: .leading) {
					ForEach(page, id: \.self) { item in
						
						WelcomeItem(image: item.imageName, text: LocalizedStringKey(item.description), title: LocalizedStringKey(item.title))
							.padding(.vertical)
					}
					.padding(.horizontal, 30)
				}
			}
		}
		.tabViewStyle(.page(indexDisplayMode: .always))
	}
	
	var columns: [GridItem] {
		[ GridItem(.flexible(minimum: 260)) ]
	}
}


// MARK: - Previews

struct WelcomePageView_Previews: PreviewProvider {
	static var previews: some View {
		WelcomePageView(welcomePages: WelcomeItemModel.welcomeItems)
	}
}
