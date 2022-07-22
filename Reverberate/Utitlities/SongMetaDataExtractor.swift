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
    
    static func extractSongMetadata(songName: String) -> SongWrapper?
    {
        let url = Bundle.main.url(forResource: songName.getNameWithoutExtension(), withExtension: songName.getExtension())
        guard let url = url else
        {
            return nil
        }
        let songWrapper = SongWrapper()
        let avUrlAsset = AVURLAsset(url: url)
        var tempPlayer: AVAudioPlayer! = try! AVAudioPlayer(contentsOf: url)
        print(tempPlayer.duration)
        songWrapper.duration = tempPlayer.duration
        print("Song duration in Seconds: \(songWrapper.duration ?? 0)")
        tempPlayer = nil
        songWrapper.artists = []
        songWrapper.url = url
        for metadataItem in avUrlAsset.commonMetadata
        {
            let key = metadataItem.commonKey
            if key == .commonKeyAlbumName
            {
                var albumName = metadataItem.stringValue!.trimmedCopy()
                if albumName.contains("(")
                {
                    albumName = String(albumName[albumName.startIndex..<albumName.firstIndex(of: "(")!]).trimmedCopy()
                }
                songWrapper.albumName = albumName
                print(songWrapper.albumName ?? "")
            }
            if key == .commonKeyTitle
            {
                songWrapper.title = metadataItem.stringValue?.trimmedCopy()
                print(songWrapper.title ?? "")
            }
            if key == .commonKeyArtist
            {
                let artistNames = metadataItem.stringValue
                guard let artistNames = artistNames else
                {
                    continue
                }
                var singers: [ArtistWrapper] = []
                if artistNames.contains(",")
                {
                    artistNames.split(separator: ",").forEach {
                        let singer = ArtistWrapper()
                        singer.name = String($0).trimmedCopy()
                        singer.parentSong = songWrapper
                        singer.artistType = .singer
                        singers.append(singer)
                    }
                }
                else if artistNames.contains("&")
                {
                    artistNames.split(separator: "&").forEach {
                        let singer = ArtistWrapper()
                        singer.name = String($0).trimmedCopy()
                        singer.parentSong = songWrapper
                        singer.artistType = .singer
                        singers.append(singer)
                    }
                }
                else
                {
                    let singer = ArtistWrapper()
                    singer.name = artistNames.trimmedCopy()
                    singer.parentSong = songWrapper
                    singer.artistType = .singer
                    singers.append(singer)
                }
                singers.forEach {
                    print("Singer: \($0.name ?? "")")
                    songWrapper.artists!.append($0)
                }
            }
            if key == .commonKeyCreator
            {
                let artistNames = metadataItem.stringValue
                guard let artistNames = artistNames else
                {
                    continue
                }
                var musicDirectors: [ArtistWrapper] = []
                if artistNames.contains(",")
                {
                    artistNames.split(separator: ",").forEach
                    {
                        let musicDirector = ArtistWrapper()
                        musicDirector.name = String($0).trimmedCopy()
                        musicDirector.parentSong = songWrapper
                        musicDirector.artistType = .musicDirector
                        musicDirectors.append(musicDirector)
                    }
                }
                else if artistNames.contains("&")
                {
                    artistNames.split(separator: "&").forEach
                    {
                        let musicDirector = ArtistWrapper()
                        musicDirector.name = String($0).trimmedCopy()
                        musicDirector.parentSong = songWrapper
                        musicDirector.artistType = .musicDirector
                        musicDirectors.append(musicDirector)
                    }
                }
                else
                {
                    let musicDirector = ArtistWrapper()
                    musicDirector.name = artistNames.trimmedCopy()
                    musicDirector.parentSong = songWrapper
                    musicDirector.artistType = .musicDirector
                    musicDirectors.append(musicDirector)
                }
                musicDirectors.forEach
                {
                    print("Music Director: \($0.name ?? "")")
                    songWrapper.artists!.append($0)
                }
            }
            if key == .commonKeyAuthor
            {
                let artistNames = metadataItem.stringValue
                guard let artistNames = artistNames else
                {
                    continue
                }
                var lyricists: [ArtistWrapper] = []
                if artistNames.contains(",")
                {
                    artistNames.split(separator: ",").forEach
                    {
                        let lyricist = ArtistWrapper()
                        lyricist.name = String($0).trimmedCopy()
                        lyricist.parentSong = songWrapper
                        lyricist.artistType = .lyricist
                        lyricists.append(lyricist)
                    }
                }
                else if artistNames.contains("&")
                {
                    artistNames.split(separator: "&").forEach
                    {
                        let lyricist = ArtistWrapper()
                        lyricist.name = String($0).trimmedCopy()
                        lyricist.parentSong = songWrapper
                        lyricist.artistType = .lyricist
                        lyricists.append(lyricist)
                    }
                }
                else
                {
                    let lyricist = ArtistWrapper()
                    lyricist.name = artistNames.trimmedCopy()
                    lyricist.parentSong = songWrapper
                    lyricist.artistType = .lyricist
                    lyricists.append(lyricist)
                }
                lyricists.forEach
                {
                    print("Lyricist: \($0.name ?? "")")
                    songWrapper.artists!.append($0)
                }
            }
            if key == .commonKeyArtwork
            {
                let cover = UIImage(data: metadataItem.dataValue!)
                guard let cover = cover else
                {
                    continue
                }
                songWrapper.coverArt = cover
                print(cover)
            }
            if key == .commonKeyCreationDate
            {
                songWrapper.dateOfPublishing = metadataItem.dateValue
                print(songWrapper.dateOfPublishing ?? "")
            }
        }
        return songWrapper
    }
}
