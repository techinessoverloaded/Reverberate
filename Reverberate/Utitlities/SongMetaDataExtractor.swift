//
//  SongMetaDataExtractor.swift
//  Reverberate
//
//  Created by arun-13930 on 15/07/22.
//
import AVKit

struct SongMetadataExtractor
{
    //Prevent Initialization
    private init() {}
    
    static func extractSongMetadata(songName: String)
    {
        let url = Bundle.main.url(forResource: songName, withExtension: "mp3")!
        let avUrlAsset = AVURLAsset(url: url)
        let songDurationInSeconds = CMTimeGetSeconds(avUrlAsset.duration)
        print("Song duration in Seconds: \(songDurationInSeconds)")
        for metadataItem in avUrlAsset.commonMetadata
        {
            let key = metadataItem.commonKey
            if key == .commonKeyAlbumName
            {
                print("Album Name: \(metadataItem.stringValue ?? "")")
            }
            if key == .commonKeyTitle
            {
                print("Song Title: \(metadataItem.stringValue ?? "")")
            }
            if key == .commonKeyArtist
            {
                print("Artist Name: \(metadataItem.stringValue ?? "")")
            }
            if key == .commonKeyCreator
            {
                print("Music Director: \(metadataItem.stringValue ?? "")")
            }
            if key == .commonKeyAuthor
            {
                print("Lyricist: \(metadataItem.stringValue ?? "")")
            }
            if key == .commonKeyArtwork
            {
                let cover = UIImage(data: metadataItem.dataValue!)!
                print("Cover: \(cover)")
            }
            if key == .commonKeyLastModifiedDate
            {
                print("Last Modified Date: \(String(describing: metadataItem.dataValue))")
            }
            if key == .commonKeyCreationDate
            {
                print("Creation Date: \(String(describing: metadataItem.dataValue))")
            }
            if key == .commonKeyIdentifier
            {
                print("ID: \(metadataItem.stringValue ?? "")")
            }
        }
        print(url)
    }
}
