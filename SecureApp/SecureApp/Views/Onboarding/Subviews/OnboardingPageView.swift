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
				VStack(alignment: .leading) {
					ForEach(page, id: \.self) { item in
						
						OnboardingItem(image: item.imageName, text: LocalizedStringKey(item.description), title: LocalizedStringKey(item.title))
							.padding(.vertical, 16)
					}
				}
				.padding(.horizontal, 16)
			}
		}
		.tabViewStyle(.page(indexDisplayMode: .always))
	}
}

