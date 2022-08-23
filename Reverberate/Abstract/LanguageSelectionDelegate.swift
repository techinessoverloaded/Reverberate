//
//  LanguageGenreSelectionDelegate.swift
//  Reverberate
//
//  Created by arun-13930 on 07/07/22.
//

protocol LanguageSelectionDelegate: AnyObject
{
    /// This method is called after the user has selected the Languages.
    func onLanguageSelection(selectedLanguages: [Int16])
}
