//
//  LanguageGenreSelectionDelegate.swift
//  Reverberate
//
//  Created by arun-13930 on 07/07/22.
//

protocol LanguageGenreSelectionDelegate: AnyObject
{
    func onSelectionConfirmation(selectedLanguages: [Int16], selectedGenres: [Int16])
}
