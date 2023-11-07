//
//  OnboardinPageView.swift
//  VINchek
//
//  Created by Aliaksei Schyslionak on 2023. 11. 04..
//

import SwiftUI

struct PageView : View {
    let title: String
    let subTitle: String
    let showDismissButton: Bool
    @Binding var shouldShowOnboarding: Bool
    var body: some View {
        VStack {
            Text(title)
                .multilineTextAlignment(.center)
                .font(.system(size: 40))
                .foregroundColor(.white)
                .padding()
            Text(subTitle)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .frame(width: 250, height: 250)
                .padding()
            
            if showDismissButton {
                Button(action: {
                    shouldShowOnboarding.toggle()
                }, label: {
                    Text("Get started")
                        .bold()
                        .foregroundColor(Color.black)
                        .frame(width: 200, height: 50)
                        .background(Color.green)
                        .cornerRadius(50)
                        .padding()
                })
            }
        }
    }
}


