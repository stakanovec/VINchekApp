//
//  MainContentView.swift
//  VINchek
//
//  Created by Aliaksei Schyslionak on 2023. 11. 04..
//

//import SwiftUI
//
//struct MainContent: View {
//    @Binding var inputText: String
//    @Binding var showAlert: Bool
//    @Binding var showResult: Bool
//    @Binding var navigated: Bool
//    @Binding var amountIsFocused: Bool
//    @ObservedObject var vm: DownloadWithCombineViewModel
//    var countCR: Int
//
//    var body: some View {
//        ZStack {
//            Image("background").resizable().edgesIgnoringSafeArea(.all)
//            VStack {
//                HeaderView(countCR: countCR)
//                InputFieldView(inputText: $inputText, showAlert: $showAlert, amountIsFocused: $amountIsFocused, vm: vm)
//                SubmitButtonView(inputText: $inputText, showResult: $showResult, vm: vm)
//                ResultsButtonView(navigated: $navigated)
//            }
//        }
//    }
//}
