//
//  ArtistType.swift
//  Reverberate
//
//  Created by arun-13930 on 20/07/22.
//

@objc public enum ArtistType: Int16, CaseIterable, CustomStringConvertible
{
    case musicDirector = 0, singer, lyricist
    public var description: String
    {
        switch self
        {
        case .musicDirector:
            return "Music Director(s)"
        case .singer:
            return "Singer(s)"
        case .lyricist:
            return "Lyricist(s)"
        }
    }
}
