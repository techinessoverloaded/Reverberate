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
    
    static func extractSongMetadata(withFileName fileName: String, ofLanguage language: Language, ofGenre genre: MusicGenre) -> Song?
    {
        guard let url = Bundle.main.url(forResource: fileName.nameWithoutExtension, withExtension: fileName.extension) as NSURL? else
        {
            return nil
        }
        let song = Song()
        let avUrlAsset = AVURLAsset(url: url as URL)
        var tempPlayer: AVAudioPlayer! = try! AVAudioPlayer(contentsOf: url as URL)
        print(tempPlayer.duration)
        song.duration = Double(tempPlayer.duration)
        print("Song duration in Seconds: \(song.duration)")
        tempPlayer = nil
        song.artists = []
        song.fileName = fileName
        song.genre = genre
        song.language = language
        for metadataItem in avUrlAsset.metadata
        {
            let key = metadataItem.commonKey
            if key == .commonKeyAlbumName
            {
                let albumName = metadataItem.stringValue!.trimmedCopy
                song.albumName = albumName
                print(song.albumName ?? "")
            }
            if key == .commonKeyTitle
            {
                song.title = metadataItem.stringValue?.trimmedCopy
                print(song.title ?? "")
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
                        let name = String($0).trimmedCopy
                        if !song.artists!.contains(where: { $0.name! == name })
                        {
                            let singer = Artist()
                            singer.name = name
                            singer.photo = UIImage(named: name.alphaNumericLowercasedString)!
                            singer.artistType = [.singer]
                            song.artists!.append(singer)
                        }
                        else
                        {
                            song.artists!.first(where: {
                                $0.name! == name
                            })!.artistType!.append(.singer)
                        }
                    }
                }
                else
                {
                    let name = artistNames.trimmedCopy
                    if !song.artists!.contains(where: { $0.name! == name })
                    {
                        let singer = Artist()
                        singer.name = name
                        singer.photo = UIImage(named: name.alphaNumericLowercasedString)!
                        singer.artistType = [.singer]
                        song.artists!.append(singer)
                    }
                    else
                    {
                        song.artists!.first(where: {
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
                        let name = String($0).trimmedCopy
                        if !song.artists!.contains(where: { $0.name! == name })
                        {
                            let musicDirector = Artist()
                            musicDirector.name = name
                            musicDirector.photo = UIImage(named: name.alphaNumericLowercasedString)!
                            musicDirector.artistType = [.musicDirector]
                            song.artists!.append(musicDirector)
                        }
                        else
                        {
                            song.artists!.first(where: {
                                $0.name! == name
                            })!.artistType!.append(.musicDirector)
                        }
                    }
                }
                else
                {
                    let name = artistNames.trimmedCopy
                    if !song.artists!.contains(where: { $0.name! == name })
                    {
                        let musicDirector = Artist()
                        musicDirector.name = name
                        musicDirector.photo = UIImage(named: name.alphaNumericLowercasedString)!
                        musicDirector.artistType = [.musicDirector]
                        song.artists!.append(musicDirector)
                    }
                    else
                    {
                        song.artists!.first(where: {
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
                        let name = String($0).trimmedCopy
                        if !song.artists!.contains(where: { $0.name! == name })
                        {
                            let lyricist = Artist()
                            lyricist.name = name
                            lyricist.photo = UIImage(named: name.alphaNumericLowercasedString)!
                            lyricist.artistType = [.lyricist]
                            song.artists!.append(lyricist)
                        }
                        else
                        {
                            song.artists!.first(where: {
                                $0.name! == name
                            })!.artistType!.append(.lyricist)
                        }
                    }
                }
                else
                {
                    let name = artistNames.trimmedCopy
                    if !song.artists!.contains(where: { $0.name! == name })
                    {
                        let lyricist = Artist()
                        lyricist.name = name
                        lyricist.photo = UIImage(named: name.alphaNumericLowercasedString)!
                        lyricist.artistType = [.lyricist]
                        song.artists!.append(lyricist)
                    }
                    else
                    {
                        song.artists!.first(where: {
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
                song.coverArt = cover
                print(cover)
            }
        }
        print("Artists: \(song.artists!)")
        return song
    }
    
    static func extractMultipleSongs(withFileNames songFileNames: [String], ofLanguageGenreAndCount languageGenreAndCount: [(language: Language, genre: MusicGenre, count: Int)]) -> [Song]
    {
        var songs: [Song?] = []
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
