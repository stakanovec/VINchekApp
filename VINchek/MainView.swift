//
//  ContentView.swift
//  VINchek
//
//  Created by Aliaksei Schyslionak on 2023. 05. 31..
//

import SwiftUI
import StoreKit
import CoreData

struct MainView: View {
    
    @AppStorage ("shouldShowOnboarding") var shouldShowOnboarding = true
    @Environment(\.managedObjectContext) private var moc
    @ObservedObject var vm = DownloadWithCombineViewModel()
    
    @FocusState private var amountIsFocused: Bool
    @State var inputText = ""
    @State var showAlert = false
    @State var showResult = false
    @State var navigated = false

    var body: some View {
        NavigationView {
            ZStack {
                AngularGradient(gradient: Gradient(colors: [Color.red, Color.yellow, Color.blue]), center: .center)
                    .edgesIgnoringSafeArea(.all)
//                  Image("background").resizable().edgesIgnoringSafeArea(.all)
                VStack {
                    VStack {
                        Text("Get VIN report for your vehicle")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 40))
                            .foregroundColor(.black)
                            .padding()
                    }
                    VStack {
                        TextField("Enter VIN, 17 characters", text: $inputText)
                        
                            .onChange(of: inputText) { newValue in
                                let filtered = newValue.filter { "0123456789ABCDEFGHJKLMNPRSTUVWXYZ".contains($0) }
                                if filtered != newValue || inputText.count > 17 {
                                    self.inputText = filtered
                                    inputText = String(inputText.prefix(17))
                                }
                                let uppercaseCount = filtered.filter { $0.isUppercase }.count
                                if inputText.count == 17 && uppercaseCount < 2 {
                                    showAlert = true
                                } else {
                                    showAlert = false
                                }
                                inputText = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
                            }
                            .autocapitalization(.allCharacters)
                            .disableAutocorrection(true)
                            .onSubmit {
                                Task {
                                    await vm.getPosts(inputText: inputText)
                                }
                            }
                            .alert(isPresented: $showAlert) {
                                Alert(title: Text("Error"), message: Text("Please enter at least 2 capital letters"), dismissButton: .default(Text("ОК")))
                            }
                            .keyboardType(.default)
                            .focused($amountIsFocused)
                            .frame(width: 250)
                            .padding()
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                            .toolbar {
                                ToolbarItemGroup(placement: .keyboard) {
                                    Spacer()
                                    Button("Done") {
                                        amountIsFocused = false
                                    }
                                }
                            }
                        Text("\(inputText.count)/17")
                            .foregroundColor(inputText.count == 17 ? .green : .gray)
                            .padding(.horizontal, 15)
                            .opacity(inputText.isEmpty ? 0 : 1)
                    }
                    VStack {
                        NavigationLink(isActive: $showResult) {
                            ResultListView(vm: vm)
                        } label: {
                            Button(action: {
                              vm.posts = []
                                Task {
                                    await vm.getPosts(inputText: inputText)
                                }
                                showResult = true
                            }) {
                                Text("Submit")
                            }
                        }
                        .foregroundColor(.white)
                        .frame(width: 200)
                        .padding()
                        .background(inputText.count == 17 ? Color.green : Color.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .disabled(inputText.count != 17)
                        .disabled(showAlert)
                    }
                    
                    VStack {
                        NavigationLink(isActive: $navigated) {
                            PDFListView()
                        } label: {
                            Button(action: {
                                navigated = true
                            }) {
                                Text("Results")
                            }
                        }
                        .foregroundColor(.white)
                        .frame(width: 200)
                        .padding()
                        .background(Color.green)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
//                .fullScreenCover(isPresented: $shouldShowOnboarding, content: {
//                    OnboardingView(shouldShowOnboarding: $shouldShowOnboarding)
//                })
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
