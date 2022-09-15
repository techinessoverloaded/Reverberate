//
//  CategoricalSong.swift
//  Reverberate
//
//  Created by arun-13930 on 15/09/22.
//

struct CategoricalSong
{
    var category: Category
    var songs: [Song]
    
    init()
    {
        self.category = .none
        self.songs = []
    }
}
