//
//  LanguageGenreSelectionDelegate.swift
//  Reverberate
//
//  Created by arun-13930 on 07/07/22.
//

protocol LanguageSelectionDelegate: AnyObject
{
    /// This method is called after the language cells have been laid out. It can be used for selecting or configuring cells from View Controllers Programmatically. It is an Optional Method.
    func languageCellsDidLoad()
    
    /// This method is called after the user has selected the Languages.
    func onLanguageSelection(selectedLanguages: [Int16])
}

extension LanguageSelectionDelegate
{
    // Default implementation
    func languageCellsDidLoad() {}
}
