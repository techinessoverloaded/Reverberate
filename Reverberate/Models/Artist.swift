//
//  Artist.swift
//  Reverberate
//
//  Created by arun-13930 on 20/07/22.
//

import Foundation
import UIKit

public class Artist: NSObject, NSSecureCoding, NSCopying, Identifiable, Comparable
{
    enum CoderKeys: String
    {
        case nameKey = "nameKey"
        case photoKey = "photoKey"
        case artistTypeKey = "artistTypeKey"
        case contributedSongsKey = "contributedSongsKey"
    }
    
    public static var supportsSecureCoding: Bool = true
    
    public var name: String? = nil
    public var photo: UIImage? = nil
    public var artistType: [ArtistType]? = nil
    public var contributedSongs: [Song]? = nil
    
    public override var description: String
    {
        "Artist(name = \(name!), artistType = \(String(describing: artistType)), contributedSongs = \(String(describing: contributedSongs))"
    }
    
    public func encode(with coder: NSCoder)
    {
        coder.encode(name, forKey: CoderKeys.nameKey.rawValue)
        coder.encode(photo, forKey: CoderKeys.photoKey.rawValue)
        let artistTypeRawValues = artistType!.map({ $0.rawValue })
        coder.encode(artistTypeRawValues, forKey: CoderKeys.artistTypeKey.rawValue)
        coder.encode(contributedSongs, forKey: CoderKeys.contributedSongsKey.rawValue)
    }
    
    public required convenience init?(coder: NSCoder)
    {
        self.init()
        self.name = coder.decodeObject(forKey: CoderKeys.nameKey.rawValue) as? String
        self.photo = coder.decodeObject(forKey: CoderKeys.photoKey.rawValue) as? UIImage
        self.artistType = (coder.decodeObject(forKey: CoderKeys.artistTypeKey.rawValue) as? [Int16])?.map({ ArtistType(rawValue: $0)! })
        self.contributedSongs = coder.decodeObject(forKey: CoderKeys.contributedSongsKey.rawValue) as? [Song]
    }
    
    public override init()
    {
        
    }
    
    public override func isEqual(_ object: Any?) -> Bool
    {
        self.name! == (object as! Self).name!
    }
    
    public static func == (lhs: Artist, rhs: Artist) -> Bool
    {
        lhs.name! == rhs.name!
    }
    
    public static func < (lhs: Artist, rhs: Artist) -> Bool
    {
        return lhs.name! < rhs.name!
    }
    
    public func copy(with zone: NSZone? = nil) -> Any
    {
        let artistCopy = Artist()
        artistCopy.name = self.name
        artistCopy.artistType = self.artistType
        artistCopy.contributedSongs = self.contributedSongs
        artistCopy.photo = self.photo
        return artistCopy
    }
    
    public func getArtistTypesAsString(separator: String = " ·") -> String
    {
        self.artistType!.map({
            let artistTypeName = $0.description
            let endIndex = artistTypeName.firstIndex(of: "(")!
            return String(artistTypeName[..<endIndex])
        }).sorted().joined(separator: "\(separator) ")
    }
}


