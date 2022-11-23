//
//  OnboardingPageView.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 20.11.2022.
//

import SwiftUI

struct OnboardingPageView: View {
	@State var onboardingPages: [[OnboardingItemModel]]

	init(onboardingPages: [[OnboardingItemModel]] = OnboardingItemModel.onboardingItems) {
		self.onboardingPages = onboardingPages
	}
	
	var body: some View {
		TabView {
			ForEach(onboardingPages, id: \.self) { page in
				LazyVGrid(columns: columns, alignment: .leading, spacing: 32) {
					ForEach(page, id: \.self) { item in

						OnboardingItem(image: item.imageName, text: LocalizedStringKey(item.description), title: LocalizedStringKey(item.title))
					}
				}
				.padding(.horizontal, 32)
			}
		}
		.tabViewStyle(.page(indexDisplayMode: .always))
		.frame(height: UIScreen.main.bounds.height / 2)
	}

	var columns: [GridItem] {
		[ GridItem(.flexible(minimum: 260)) ]
	}
}


// MARK: - Previews

struct OnboardingPageView_Previews: PreviewProvider {
	static var previews: some View {
		OnboardingPageView(onboardingPages: OnboardingItemModel.onboardingItems)
	}
}
