//
//  Artist+CoreDataProperties.swift
//  Reverberate
//
//  Created by arun-13930 on 29/07/22.
//
//

import Foundation
import CoreData


extension Artist {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Artist> {
        return NSFetchRequest<Artist>(entityName: "Artist")
    }

    @NSManaged public var artistType: [Int16]?
    @NSManaged public var name: String?
    @NSManaged public var photo: Data?
    @NSManaged public var parentSong: Song?
    @NSManaged public var contributedSongs: NSSet?

}

// MARK: Generated accessors for contributedSongs
extension Artist {

    @objc(addContributedSongsObject:)
    @NSManaged public func addToContributedSongs(_ value: Song)

    @objc(removeContributedSongsObject:)
    @NSManaged public func removeFromContributedSongs(_ value: Song)

    @objc(addContributedSongs:)
    @NSManaged public func addToContributedSongs(_ values: NSSet)

    @objc(removeContributedSongs:)
    @NSManaged public func removeFromContributedSongs(_ values: NSSet)

}

extension Artist : Identifiable {

}
