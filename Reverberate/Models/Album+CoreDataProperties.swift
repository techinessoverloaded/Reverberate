//
//  Album+CoreDataProperties.swift
//  Reverberate
//
//  Created by arun-13930 on 01/08/22.
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
    @NSManaged public var composers: NSSet?

}

// MARK: Generated accessors for composers
extension Album {

    @objc(addComposersObject:)
    @NSManaged public func addToComposers(_ value: Artist)

    @objc(removeComposersObject:)
    @NSManaged public func removeFromComposers(_ value: Artist)

    @objc(addComposers:)
    @NSManaged public func addToComposers(_ values: NSSet)

    @objc(removeComposers:)
    @NSManaged public func removeFromComposers(_ values: NSSet)

}
