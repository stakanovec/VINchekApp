//
//  OnLoaded.swift
//  VINchek
//
//  Created by Aliaksei Schyslionak on 2023. 05. 31..
//

import Foundation
import SwiftUI

struct OnboardingView: View {
    @Binding var shouldShowOnboarding: Bool
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            TabView {
                PageView(
                    title: "Get report for your vehicle",
                    subTitle: "You can use our information to check for incorrect or missing information in the advertisement.",
                    showDismissButton: false,
                    shouldShowOnboarding: $shouldShowOnboarding
                )
                PageView(
                    title: "Get report for your vehicle",
                    subTitle: "With our Vehicle History Reports, you can identify risks and make an informed buying decision.",
                    showDismissButton: true,
                    shouldShowOnboarding: $shouldShowOnboarding
                )
            }
            .tabViewStyle(PageTabViewStyle())
        }
        .edgesIgnoringSafeArea(.all)
    }
}
