//
//  Artist+CoreDataProperties.swift
//  Reverberate
//
//  Created by arun-13930 on 20/07/22.
//
//

import Foundation
import CoreData


extension Artist {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Artist> {
        return NSFetchRequest<Artist>(entityName: "Artist")
    }

    @NSManaged public var name: String?
    @NSManaged public var photo: Data?
    @NSManaged public var artistType: Int16
    @NSManaged public var parentSong: Song?

}

extension Artist : Identifiable {

}
