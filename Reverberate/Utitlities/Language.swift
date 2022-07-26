//
//  Language.swift
//  Reverberate
//
//  Created by arun-13930 on 07/07/22.
//

import UIKit

@objc enum Language: Int16, CaseIterable, CustomStringConvertible
{
    case tamil = 0, malayalam, telugu, hindi, kannada, english
    
    var description: String
    {
        switch self
        {
        case .tamil:
            return "Tamil"
        case .malayalam:
            return "Malayalam"
        case .telugu:
            return "Telugu"
        case .hindi:
            return "Hindi"
        case .kannada:
            return "Kannada"
        case .english:
            return "English"
        }
    }
    
    var titleAndScript: (String?, String)
    {
        switch self
        {
        case .tamil:
            return ("Tamil", "தமிழ்")
        case .malayalam:
            return ("Malayalam", "മലയാളം")
        case .telugu:
            return ("Telugu", "తెలుగు")
        case .hindi:
            return ("Hindi", "हिंदी")
        case .kannada:
            return ("Kannada", "ಕನ್ನಡ")
        case .english:
            return (nil, "English")
        }
    }
    
    var preferredBackgroundColor: UIColor
    {
        switch self
        {
        case .tamil:
            return .systemPurple
        case .malayalam:
            return .systemBrown
        case .hindi:
            return .systemBlue
        case .telugu:
            return .systemPink
        case .kannada:
            return .systemOrange
        case .english:
            return .systemIndigo
        }
    }
}
