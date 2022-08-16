//
//  Category.swift
//  Reverberate
//
//  Created by arun-13930 on 21/07/22.
//

enum Category: Int, CaseIterable, CustomStringConvertible
{
    case starter = 0, newReleases = 1, topCharts = 2, tamil = 3, malayalam = 4, kannada = 5, telugu = 6, hindi = 7, melody = 8, western = 9, classical = 10, rock = 11, folk = 12, recentlyPlayed = 13
    
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
        }
    }
}
