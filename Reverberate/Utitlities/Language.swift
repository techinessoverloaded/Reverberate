//
//  Language.swift
//  Reverberate
//
//  Created by arun-13930 on 07/07/22.
//
enum Language: Int16, CaseIterable, CustomStringConvertible
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
}
