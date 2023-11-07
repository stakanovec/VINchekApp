//
//  PDF+CoreDataProperties.swift
//  VINchek
//
//  Created by Aliaksei Schyslionak on 2023. 05. 31..
//
//

import Foundation
import CoreData

extension PDF {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PDF> {
        return NSFetchRequest<PDF>(entityName: "PDF")
    }
    
    @NSManaged public var data: Data?
    @NSManaged public var date: Date?
    @NSManaged public var id: String?
    @NSManaged public var vin: String?
    
    public var wrappedId: String {
        id ?? "Unknown Id"
    }
    
    public var wrappedVin: String {
        vin ?? "Unknown Vin"
    }
    
}

extension PDF : Identifiable {
    
}
