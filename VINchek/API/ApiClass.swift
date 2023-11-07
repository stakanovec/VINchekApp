//
//  API.swift
//  VINchek
//
//  Created by Aliaksei Schyslionak on 2023. 05. 31..
//

import CoreData
import SwiftUI

@MainActor
class DownloadWithCombineViewModel: ObservableObject {
    
    @Published var pdfDatas: [Data] = []
    @Published var posts: [PostModel] = []
    @Published var showAlert = false
    
    func getPosts(inputText: String) async {
        guard let urlv = URL(string: "https://asm-parser-production.up.railway.app/vin?sid=\(inputText)") else {
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: urlv)
            let post = try JSONDecoder().decode(PostModel.self, from: data)
            
            guard let pdfUrl = post.url else {
                return
            }
            
            do {
                let (pdfData, _) = try await URLSession.shared.data(from: pdfUrl)
                self.pdfDatas.append(pdfData)
                
                let moc = PersistenceController.shared.container.viewContext
                let pdf = PDF(context: moc)
                pdf.id = post.id
                pdf.data = pdfData
                pdf.vin = inputText
                pdf.date = Date()
//              pdf.report = post.report
                
                let updatedPost = PostModel(id: post.id, url: post.url, report: post.report)
                self.posts.append(updatedPost)
                
                try? moc.save()
                
            } catch {
                print("Error downloading PDF: \(error)")
            }
            
        } catch {
            self.showAlert = true
            print("Error saving to CoreData: \(error)")
        }
    }
}
