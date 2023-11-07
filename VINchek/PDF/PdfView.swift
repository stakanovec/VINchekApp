//
//  PdfView.swift
//  VINchek
//
//  Created by Aliaksei Schyslionak on 2023. 06. 01..
//

import SwiftUI
import PDFKit
import CoreData

struct PDFView: UIViewRepresentable {
    
    let pdfId: String
    @Environment(\.managedObjectContext) private var moc
    
    func makeUIView(context: Context) -> PDFKit.PDFView {
        return PDFKit.PDFView()
    }
    
    func updateUIView(_ uiView: PDFKit.PDFView, context: Context) {
        guard let pdf = fetchPDF() else { return }
        uiView.document = PDFDocument(data: pdf.data!)
        uiView.autoScales = true
    }
    
    private func fetchPDF() -> PDF? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PDF")
        fetchRequest.predicate = NSPredicate(format: "id == %@", pdfId)
        
        do {
            let result = try moc.fetch(fetchRequest)
            if let pdf = result.first as? PDF {
                return pdf
            }
        } catch {
            print("Failed to fetch PDF data: \(error)")
        }
        return nil
    }
}
