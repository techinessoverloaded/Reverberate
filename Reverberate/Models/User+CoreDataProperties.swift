//
//  User+CoreDataProperties.swift
//  Reverberate
//
//  Created by arun-13930 on 08/09/22.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var email: String?
    @NSManaged public var favouriteArtists: [Artist]?
    @NSManaged public var favouritePlaylists: [Playlist]?
    @NSManaged public var favouriteSongs: [Song]?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var password: String?
    @NSManaged public var phone: String?
    @NSManaged public var preferredGenres: [Int16]?
    @NSManaged public var preferredLanguages: [Int16]?
    @NSManaged public var profilePicture: Data?

}

extension User : Identifiable {

}
