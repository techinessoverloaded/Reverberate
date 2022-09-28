//
//  GenreSelectionDelegate.swift
//  Reverberate
//
//  Created by arun-13930 on 08/07/22.
//

protocol GenreSelectionDelegate: AnyObject
{
    /// This method is called after the user has selected the Music Genres.
    func onGenreSelection(selectedGenres: [Int16])
    
    func onGenreSelectionDismissRequest()
}
