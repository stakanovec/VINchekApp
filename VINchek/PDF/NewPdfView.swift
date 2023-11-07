//
//  SwiftUIView.swift
//  VINchek
//
//  Created by Aliaksei Schyslionak on 2023. 06. 01..
//

import SwiftUI

struct ResultListView: View {
//    @Environment(\.managedObjectContext) private var moc
    @ObservedObject var vm = DownloadWithCombineViewModel()
    @State private var isLoading = true
    @State private var isShowingResultView = false
    @Environment(\.presentationMode) var presentationMode
    
    init(vm: DownloadWithCombineViewModel) {
        self.vm = vm
    }
    
    var body: some View {
        
        ZStack {
            Image("background").resizable().edgesIgnoringSafeArea(.all)
            
//            if isLoading {
//                ProgressView("Loading... Please wait.")
//                    .progressViewStyle(CircularProgressViewStyle())
//                    .foregroundColor(.white)
//                    .scaleEffect(2)
//            }
            
            List(vm.posts) { post in
                NavigationLink(destination: PDFView(pdfId: post.id)) {
                    Text("View report \(post.id)")
                    Image(systemName: "doc.text")
                }
                HStack {
                    Text("Save and share")
                    Button(action: {
                        
                        let pdfData = vm.pdfDatas.first
                        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                        let fileURL = documentDirectory.appendingPathComponent("\(post.id).pdf")
                        
                        do {
                            try pdfData!.write(to: fileURL)
                            print("File saved")
                            let activityVC = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
                            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                               let window = windowScene.windows.first {
                                window.rootViewController?.present(activityVC, animated: true, completion: nil)
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }) {
                        Image(systemName: "square.and.arrow.down")
                    }
                }
            }
            .navigationTitle("Report")
            .alert(isPresented: $vm.showAlert) {
                Alert(title: Text("Error"), message: Text("VIN"), dismissButton: .default(Text("OK"), action: {
                    presentationMode.wrappedValue.dismiss()
                }))
            }
        }
//        .onDisappear {
//            vm.posts = []
//            isLoading = true
//        }
    }
}


