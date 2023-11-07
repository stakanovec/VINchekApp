//
//  SwiftUIView.swift
//  VINchek
//
//  Created by Aliaksei Schyslionak on 2023. 11. 03..
//

//
//  PDFListView.swift
//  VinApp
//
//  Created by Aliaksei Schyslionak on 2023. 04. 28..
//

import SwiftUI
import CoreData
import PDFKit

struct PDFListView: View {

    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)])
    var pdfs: FetchedResults<PDF>
    @Environment(\.managedObjectContext) var moc

    var body: some View {
        ZStack {
            Image("background").resizable().edgesIgnoringSafeArea(.all)
            ScrollView {
                ForEach(Array(pdfs.enumerated()), id: \.element) { (index, pdf) in
                    NavigationLink(destination: PDFView(pdfId: pdf.wrappedId)) {
                        GeometryReader { geometry in
                            HStack {
                                VStack {
                                    Text("\(index + 1).")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .frame(width: geometry.size.width * 0.1)
                                }
                                VStack {
                                    Text("VIN: \(pdf.wrappedVin)")
                                    Text("\(pdf.date ?? Date(), formatter: itemFormatter)")
                                }
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(width: geometry.size.width * 0.4)

                                Button {
                                    saveAndSharePDF(pdf)
                                } label: {
                                    VStack {
                                        Text("Save")
                                        Image(systemName: "square.and.arrow.down")
                                    }
                                }
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(width: geometry.size.width * 0.25)
                                Button {
                                    deletePDF(pdf)
                                } label: {
                                    VStack {
                                        Text("Delete")
                                        Image(systemName: "trash")
                                    }
                                }
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(width: geometry.size.width * 0.25)
                            }
                        }
                        .background(.green)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .frame(height: 80)
                    }
                }
            }
            .navigationTitle("Carfax report history")
        }
    }
    func deletePDF(_ pdf: PDF) {
        moc.delete(pdf)
        do {
            try moc.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { pdfs[$0] }.forEach(moc.delete)
            do {
                try moc.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    func saveAndSharePDF(_ pdf: PDF) {
        if let pdfData = pdf.data {
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentDirectory.appendingPathComponent("\(pdf.wrappedVin).pdf")

            do {
                try pdfData.write(to: fileURL)
                print("File saved")
                let activityVC = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first {
                    window.rootViewController?.present(activityVC, animated: true, completion: nil)
                }
                //                UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

struct PDFListView_Previews: PreviewProvider {
    static var previews: some View {
        PDFListView()
    }
}

