//
//  Song+CoreDataProperties.swift
//  Reverberate
//
//  Created by arun-13930 on 15/07/22.
//
//

import Foundation
import CoreData


extension Song {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Song> {
        return NSFetchRequest<Song>(entityName: "Song")
    }

    @NSManaged public var title: String?
    @NSManaged public var coverArt: Data?
    @NSManaged public var singerNames: [String]?
    @NSManaged public var musicDirectorNames: [String]?
    @NSManaged public var albumName: String?
    @NSManaged public var duration: Float
    @NSManaged public var lyricistName: String?
    @NSManaged public var dateOfPublishing: Date?
    @NSManaged public var relationship: Playlist?

}

extension Song : Identifiable {

}
