//
//  GenreSelectionDelegate.swift
//  Reverberate
//
//  Created by arun-13930 on 08/07/22.
//

protocol GenreSelectionDelegate: AnyObject
{
    /// This method is called after the genre cells have been laid out. It can be used for selecting or configuring cells from View Controllers Programmatically. It is an Optional Method.
    func genreCellsDidLoad()
    
    /// This method is called after the user has selected the Music Genres.
    func onGenreSelection(selectedGenres: [Int16])
}

extension GenreSelectionDelegate
{
    // Default Implementation
    func genreCellsDidLoad() {}
}
