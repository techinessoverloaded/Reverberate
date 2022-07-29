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
    
    static func extractSongMetadata(withFileName fileName: String, ofLanguage language: Language, ofGenre genre: MusicGenre) -> SongWrapper?
    {
        let url = Bundle.main.url(forResource: fileName.getNameWithoutExtension(), withExtension: fileName.getExtension())
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
        songWrapper.genre = genre
        songWrapper.language = language
        for metadataItem in avUrlAsset.metadata
        {
            let key = metadataItem.commonKey
            if key == .commonKeyAlbumName
            {
                let albumName = metadataItem.stringValue!.trimmedCopy()
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
                if artistNames.contains(",")
                {
                    artistNames.split(separator: ",").forEach {
                        let name = String($0).trimmedCopy()
                        if !songWrapper.artists!.contains(where: { $0.name! == name })
                        {
                            let singer = ArtistWrapper()
                            singer.name = name
                            singer.photo = UIImage(named: name.getAlphaNumericLowercasedString())!
                            singer.artistType = [.singer]
                            songWrapper.artists!.append(singer)
                        }
                        else
                        {
                            songWrapper.artists!.first(where: {
                                $0.name! == name
                            })!.artistType!.append(.singer)
                        }
                    }
                }
                else
                {
                    let name = artistNames.trimmedCopy()
                    if !songWrapper.artists!.contains(where: { $0.name! == name })
                    {
                        let singer = ArtistWrapper()
                        singer.name = name
                        singer.photo = UIImage(named: name.getAlphaNumericLowercasedString())!
                        singer.artistType = [.singer]
                        songWrapper.artists!.append(singer)
                    }
                    else
                    {
                        songWrapper.artists!.first(where: {
                            $0.name! == name
                        })!.artistType!.append(.singer)
                    }
                }
            }
            if key == .commonKeyCreator
            {
                let artistNames = metadataItem.stringValue
                guard let artistNames = artistNames else
                {
                    continue
                }
                if artistNames.contains(",")
                {
                    artistNames.split(separator: ",").forEach {
                        let name = String($0).trimmedCopy()
                        if !songWrapper.artists!.contains(where: { $0.name! == name })
                        {
                            let musicDirector = ArtistWrapper()
                            musicDirector.name = name
                            musicDirector.photo = UIImage(named: name.getAlphaNumericLowercasedString())!
                            musicDirector.artistType = [.musicDirector]
                            songWrapper.artists!.append(musicDirector)
                        }
                        else
                        {
                            songWrapper.artists!.first(where: {
                                $0.name! == name
                            })!.artistType!.append(.musicDirector)
                        }
                    }
                }
                else
                {
                    let name = artistNames.trimmedCopy()
                    if !songWrapper.artists!.contains(where: { $0.name! == name })
                    {
                        let musicDirector = ArtistWrapper()
                        musicDirector.name = name
                        musicDirector.photo = UIImage(named: name.getAlphaNumericLowercasedString())!
                        musicDirector.artistType = [.musicDirector]
                        songWrapper.artists!.append(musicDirector)
                    }
                    else
                    {
                        songWrapper.artists!.first(where: {
                            $0.name! == name
                        })!.artistType!.append(.musicDirector)
                    }
                }
            }
            if key == .commonKeyAuthor
            {
                let artistNames = metadataItem.stringValue
                guard let artistNames = artistNames else
                {
                    continue
                }
                if artistNames.contains(",")
                {
                    artistNames.split(separator: ",").forEach {
                        let name = String($0).trimmedCopy()
                        if !songWrapper.artists!.contains(where: { $0.name! == name })
                        {
                            let lyricist = ArtistWrapper()
                            lyricist.name = name
                            lyricist.photo = UIImage(named: name.getAlphaNumericLowercasedString())!
                            lyricist.artistType = [.lyricist]
                            songWrapper.artists!.append(lyricist)
                        }
                        else
                        {
                            songWrapper.artists!.first(where: {
                                $0.name! == name
                            })!.artistType!.append(.lyricist)
                        }
                    }
                }
                else
                {
                    let name = artistNames.trimmedCopy()
                    if !songWrapper.artists!.contains(where: { $0.name! == name })
                    {
                        let lyricist = ArtistWrapper()
                        lyricist.name = name
                        lyricist.photo = UIImage(named: name.getAlphaNumericLowercasedString())!
                        lyricist.artistType = [.lyricist]
                        songWrapper.artists!.append(lyricist)
                    }
                    else
                    {
                        songWrapper.artists!.first(where: {
                            $0.name! == name
                        })!.artistType!.append(.lyricist)
                    }
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
        }
        print("Artists: \(songWrapper.artists!)")
        return songWrapper
    }
    
    static func extractMultipleSongs(withFileNames songFileNames: [String], ofLanguageGenreAndCount languageGenreAndCount: [(language: Language, genre: MusicGenre, count: Int)]) -> [SongWrapper]
    {
        var songs: [SongWrapper?] = []
        var index = 0
        var offset = 0
        for lgc in languageGenreAndCount
        {
            while index < (offset + lgc.count)
            {
                songs.append(extractSongMetadata(withFileName: songFileNames[index], ofLanguage: lgc.language, ofGenre: lgc.genre))
                index += 1
            }
            offset = index
        }
        return songs.compactMap { $0 }
    }
}
