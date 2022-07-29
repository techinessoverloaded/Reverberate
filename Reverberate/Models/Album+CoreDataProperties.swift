//
//  Album+CoreDataProperties.swift
//  Reverberate
//
//  Created by arun-13930 on 29/07/22.
//
//

import Foundation
import CoreData


extension Album {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Album> {
        return NSFetchRequest<Album>(entityName: "Album")
    }

    @NSManaged public var coverArt: Data?
    @NSManaged public var releaseDate: Date?

}
