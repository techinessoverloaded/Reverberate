//
//  Song+CoreDataProperties.swift
//  Reverberate
//
//  Created by arun-13930 on 21/07/22.
//
//

import Foundation
import CoreData


extension Song {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Song> {
        return NSFetchRequest<Song>(entityName: "Song")
    }

    @NSManaged public var albumName: String?
    @NSManaged public var coverArt: Data?
    @NSManaged public var dateOfPublishing: Date?
    @NSManaged public var duration: Double
    @NSManaged public var title: String?
    @NSManaged public var url: URL?
    @NSManaged public var artists: NSSet?
    @NSManaged public var parentPlaylist: Playlist?

}

// MARK: Generated accessors for artists
extension Song {

    @objc(addArtistsObject:)
    @NSManaged public func addToArtists(_ value: Artist)

    @objc(removeArtistsObject:)
    @NSManaged public func removeFromArtists(_ value: Artist)

    @objc(addArtists:)
    @NSManaged public func addToArtists(_ values: NSSet)

    @objc(removeArtists:)
    @NSManaged public func removeFromArtists(_ values: NSSet)

}

extension Song : Identifiable {

}
