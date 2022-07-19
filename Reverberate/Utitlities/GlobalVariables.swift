//
//  GlobalVariables.swift
//  Reverberate
//
//  Created by arun-13930 on 19/07/22.
//

struct GlobalVariables
{
    // Prevent Initialization
    private init() {}
    
    static var availableSongs: [Language: [MusicGenre: Song]] = [:]
}
