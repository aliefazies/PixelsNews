//
//  NewsData+CoreDataProperties.swift
//  
//
//  Created by Alief Azies on 25/10/21.
//
//

import Foundation
import CoreData


extension NewsData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsData> {
        return NSFetchRequest<NewsData>(entityName: "NewsData")
    }
    
    @NSManaged public var id: Int64
    @NSManaged public var title: String
    @NSManaged public var abstract: String
    @NSManaged public var section: String
    @NSManaged public var published_date: Date
    @NSManaged public var url: String
    @NSManaged public var thumb: String
    @NSManaged public var isActive: Bool

}
