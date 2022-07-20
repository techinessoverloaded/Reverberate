//
//  User+CoreDataProperties.swift
//  Reverberate
//
//  Created by arun-13930 on 20/07/22.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var email: String?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var password: String?
    @NSManaged public var phone: String?
    @NSManaged public var preferredGenres: [Int16]?
    @NSManaged public var preferredLanguages: [Int16]?
    @NSManaged public var profilePicture: Data?
    @NSManaged public var favouriteSongs: Playlist?
    @NSManaged public var favouritePlaylists: NSSet?

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

extension User : Identifiable {

}
