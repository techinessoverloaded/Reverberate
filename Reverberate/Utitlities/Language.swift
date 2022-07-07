//
//  Language.swift
//  Reverberate
//
//  Created by arun-13930 on 07/07/22.
//

import UIKit
enum Language: Int16, CaseIterable
{
    case tamil = 0, malayalam, telugu, hindi, kannada, english
    
    var titleAndLetter: (String?, String)
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
