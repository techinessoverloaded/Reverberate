//
//  DataManager.swift
//  Reverberate
//
//  Created by arun-13930 on 25/07/22.
//

import Foundation

class DataManager
{
    // Singleton Object
    static let shared = DataManager()
    
    // Prevent Instantiation
    private init() {}
    
    func extractSongsAndPlaylistsData()
    {
        let songCache = NSCache<NSString, NSDictionary>()
        
        let availableSongs = NSDictionary<Language, NSDictionary>()
        
        
        
    }
}
