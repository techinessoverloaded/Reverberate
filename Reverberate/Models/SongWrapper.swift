//
//  SongWrapper.swift
//  Reverberate
//
//  Created by arun-13930 on 20/07/22.
//

import UIKit

class SongWrapper: Identifiable, Hashable
{
    private lazy var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    public var albumName: String?
    public var coverArt: UIImage?
    public var dateOfPublishing: Date?
    public var duration: Double?
    public var title: String?
    public var parentPlaylist: PlaylistWrapper?
    public var artists: [ArtistWrapper]?
    public var url: URL?
    
    func emitAsCoreDataObject() -> Song
    {
        let song = Song(context: context)
        song.albumName = self.albumName
        song.coverArt = self.coverArt!.jpegData(compressionQuality: 1)
        song.dateOfPublishing = self.dateOfPublishing
        song.duration = self.duration!
        song.title = self.title
        song.url = self.url
        song.parentPlaylist = self.parentPlaylist!.emitAsCoreDataObject()
        var artistSet = Set<Artist>()
        artists!.forEach {
            artistSet.insert($0.emitAsCoreDataObject())
        }
        song.addToArtists(NSSet(set: artistSet))
        return song
    }
    
    static func == (lhs: SongWrapper, rhs: SongWrapper) -> Bool
    {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher)
    {
        hasher.combine(self)
    }
    
    func getArtistNamesAsString() -> String
    {
        let artistNameArray = artists!.map {
            $0.name!
        }
        return artistNameArray.joined(separator: ", ")
    }
}
