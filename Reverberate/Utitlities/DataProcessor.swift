//
//  QueryProcessor.swift
//  Reverberate
//
//  Created by arun-13930 on 27/07/22.
//

class DataProcessor
{
    //Singleton
    static let shared = DataProcessor()
    
    //Prevent Initialization
    private init() {}
    
    func getSongsThatSatisfy(theQuery query: String) -> [SongWrapper]?
    {
        var querySet: Set<SongWrapper> = []
        for song in DataManager.shared.availableSongs
        {
            if song.albumName!.contains(query) || song.title!.contains(query) || song.language!.description.contains(query) || song.genre!.description.contains(query) || song.artists!.contains(where: { $0.name!.contains(query) })
            {
                querySet.insert(song)
            }
        }
        return querySet.isEmpty ? nil : Array(querySet)
    }
}
