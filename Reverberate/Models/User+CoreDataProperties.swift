//
//  User+CoreDataProperties.swift
//  Reverberate
//
//  Created by arun-13930 on 05/08/22.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var email: String?
    @NSManaged public var favSongs: [Song]?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var password: String?
    @NSManaged public var phone: String?
    @NSManaged public var preferredGenres: [Int16]?
    @NSManaged public var preferredLanguages: [Int16]?
    @NSManaged public var profilePicture: Data?
    @NSManaged public var favouritePlaylists: NSSet?
    @NSManaged public var favouriteSongs: NSSet?

}

// MARK: Generated accessors for favouritePlaylists
extension User {

    @objc(addFavouritePlaylistsObject:)
    @NSManaged public func addToFavouritePlaylists(_ value: Playlist)

    @objc(removeFavouritePlaylistsObject:)
    @NSManaged public func removeFromFavouritePlaylists(_ value: Playlist)

    @objc(addFavouritePlaylists:)
    @NSManaged public func addToFavouritePlaylists(_ values: NSSet)

    @objc(removeFavouritePlaylists:)
    @NSManaged public func removeFromFavouritePlaylists(_ values: NSSet)

}

// MARK: Generated accessors for favouriteSongs
extension User {

    @objc(addFavouriteSongsObject:)
    @NSManaged public func addToFavouriteSongs(_ value: Song)

    @objc(removeFavouriteSongsObject:)
    @NSManaged public func removeFromFavouriteSongs(_ value: Song)

    @objc(addFavouriteSongs:)
    @NSManaged public func addToFavouriteSongs(_ values: NSSet)

    @objc(removeFavouriteSongs:)
    @NSManaged public func removeFromFavouriteSongs(_ values: NSSet)

}

extension User : Identifiable {

}
