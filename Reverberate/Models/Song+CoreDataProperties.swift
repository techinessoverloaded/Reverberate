//
//  Song+CoreDataProperties.swift
//  Reverberate
//
//  Created by arun-13930 on 29/07/22.
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
    @NSManaged public var duration: Double
    @NSManaged public var genre: Int16
    @NSManaged public var language: Int16
    @NSManaged public var title: String?
    @NSManaged public var url: URL?
    @NSManaged public var artists: NSSet?
    @NSManaged public var parentArtist: Artist?
    @NSManaged public var parentPlaylist: Playlist?
    @NSManaged public var parentUser: User?

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
