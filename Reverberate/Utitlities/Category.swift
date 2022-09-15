//
//  Category.swift
//  Reverberate
//
//  Created by arun-13930 on 21/07/22.
//

enum Category: Int, CaseIterable, CustomStringConvertible
{
    case recentlyPlayed = 0, starter, newReleases, topCharts , tamil, malayalam, kannada, telugu, hindi, melody, western, classical, rock, folk, none = -1
    
    var description: String
    {
        switch self
        {
        case .newReleases:
            return "New Releases"
        case .starter:
            return "To get you started"
        case .topCharts:
            return "Top Charts"
        case .tamil:
            return "Tamil"
        case .malayalam:
            return "Malayalam"
        case .kannada:
            return "Kannada"
        case .telugu:
            return "Telugu"
        case .hindi:
            return "Hindi"
        case .melody:
            return "Melody"
        case .western:
            return "Western"
        case .classical:
            return "Classical"
        case .rock:
            return "Rock"
        case .folk:
            return "Folk"
        case .recentlyPlayed:
            return "Recently Played"
        case .none:
            return "None"
        }
    }
    
    static func getCategoryFromDescription(_ text: String) -> Category?
    {
        switch text
        {
        case "New Releases":
            return .newReleases
        case "To get you started":
            return .starter
        case "Top Charts":
            return .topCharts
        case "Tamil":
            return .tamil
        case "Malayalam":
            return .malayalam
        case "Kannada":
            return .kannada
        case "Telugu":
            return .telugu
        case "Hindi":
            return .hindi
        case "Melody":
            return .melody
        case "Western":
            return .western
        case "Classical":
            return .classical
        case "Rock":
            return .rock
        case "Folk":
            return .folk
        case "Recently Played":
            return .recentlyPlayed
        default:
            return Category.none
        }
    }
    
    static func getCategoryOfLanguage(_ language: Language) -> Self?
    {
        switch language
        {
        case .tamil:
            return .tamil
        case .malayalam:
            return .malayalam
        case .telugu:
            return .telugu
        case .hindi:
            return .hindi
        case .kannada:
            return .kannada
        case .none:
            return Category.none
        }
    }
    
    static func getCategoryOfGenre(_ genre: MusicGenre) -> Self?
    {
        switch genre
        {
        case .classical:
            return .classical
        case .melody:
            return .melody
        case .western:
            return .western
        case .rock:
            return .rock
        case .folk:
            return .folk
        case .none:
            return Category.none
        }
    }
}
