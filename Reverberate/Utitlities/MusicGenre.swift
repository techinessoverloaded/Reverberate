//
//  MusicGenre.swift
//  Reverberate
//
//  Created by arun-13930 on 07/07/22.
//

import UIKit

@objc public enum MusicGenre: Int16, CaseIterable, CustomStringConvertible
{
    case classical = 0, melody, western, rock, folk
    
    public var description: String
    {
        switch self
        {
        case .classical:
            return "Classical"
        case .melody:
            return "Melody"
        case .western:
            return "Western"
        case .rock:
            return "Rock"
        case .folk:
            return "Folk"
        }
    }
    
    var preferredBackgroundColor: UIColor
    {
        switch self
        {
        case .classical:
            return .systemIndigo
        case .melody:
            return .systemBlue
        case .folk:
            return .systemRed
        case .rock:
            return .systemPink
        case .western:
            return .systemPurple
        }
    }
}
