//
//  ArtistType.swift
//  Reverberate
//
//  Created by arun-13930 on 20/07/22.
//

enum ArtistType: Int16, CaseIterable, CustomStringConvertible
{
    case musicDirector = 0, singer, lyricist
    var description: String
    {
        switch self
        {
        case .musicDirector:
            return "Music Director"
        case .singer:
            return "Singer"
        case .lyricist:
            return "Lyricist"
        }
    }
}
