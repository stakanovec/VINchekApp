//
//  ApiModel.swift
//  VINchek
//
//  Created by Aliaksei Schyslionak on 2023. 05. 31..
//

import Foundation

struct PostModel: Identifiable, Codable {
    let id: String
    let url: URL?
    let report: String
}
