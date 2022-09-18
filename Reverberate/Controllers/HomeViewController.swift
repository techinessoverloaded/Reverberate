//
//  HomeViewController.swift
//  Reverberate
//
//  Created by arun-13930 on 07/07/22.
//
import UIKit
import MediaPlayer

class HomeViewController: UICollectionViewController
{
    private lazy var songs : [CategoricalSong] = prepareSongs()
    
    private var playlists: [Category: Playlist] = [:]

    private var keys: [Category]
    {
        get
        {
            songs.map({$0.category})
        }
    }
    
    private var didDisplayRecentlyPlayedSongs: Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        self.navigationController?.navigationBar.prefersLargeTitles = true
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
        collectionView.register(PosterDetailCVCell.self, forCellWithReuseIdentifier: PosterDetailCVCell.identifier)
        collectionView.register(HeaderCVReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCVReusableView.identifier)
        collectionView.backgroundColor = .clear
        collectionView.bounces = true
        NotificationCenter.default.addObserver(self, selector: #selector(onRecentlyPlayedListChange), name: .recentlyPlayedListChangedNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(performReload), name: .userLoggedInNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(performReload), name: .languageGenreChangeNotification, object: nil)
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self, name: .recentlyPlayedListChangedNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: .userLoggedInNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: .languageGenreChangeNotification, object: nil)
    }
    
    private func createMenu(song: Song) -> UIMenu
    {
        return ContextMenuProvider.shared.getSongMenu(song: song, requesterId: GlobalVariables.shared.mainTabController.requesterId)
    }
    
    private func prepareSongs() -> [CategoricalSong]
    {
        var result: [CategoricalSong] = []
        let primaryCategories: [Category] = GlobalVariables.shared.recentlyPlayedSongNames.isEmpty ? [.starter, .topCharts, .newReleases] : [.recentlyPlayed, .starter, .topCharts, .newReleases]
        didDisplayRecentlyPlayedSongs = !GlobalVariables.shared.recentlyPlayedSongNames.isEmpty
        for category in primaryCategories
        {
            var newCategoricalSong = CategoricalSong()
            newCategoricalSong.category = category
            newCategoricalSong.songs = DataProcessor.shared.getSongsOf(category: category, andLimitNumberOfResultsTo: 10)
            result.append(newCategoricalSong)
        }
        var preferredLanguages: [Int16]
        var preferredGenres: [Int16]
        if !SessionManager.shared.isUserLoggedIn
        {
            preferredLanguages = UserDefaults.standard.object(forKey: GlobalConstants.preferredLanguages) as! [Int16]
            preferredGenres = UserDefaults.standard.object(forKey: GlobalConstants.preferredLanguages) as! [Int16]
        }
        else
        {
            preferredLanguages = GlobalVariables.shared.currentUser!.preferredLanguages!
            preferredGenres = GlobalVariables.shared.currentUser!.preferredGenres!
        }
        preferredLanguages.forEach {
            let category = Category.getCategoryOfLanguage(Language(rawValue: $0)!)!
            var newCategoricalSong = CategoricalSong()
            newCategoricalSong.category = category
            newCategoricalSong.songs = DataProcessor.shared.getSongsOf(category: category, andLimitNumberOfResultsTo: 10)
            result.append(newCategoricalSong)
        }
        preferredGenres.forEach {
            let category = Category.getCategoryOfGenre(MusicGenre(rawValue: $0)!)!
            var newCategoricalSong = CategoricalSong()
            newCategoricalSong.category = category
            newCategoricalSong.songs = DataProcessor.shared.getSongsOf(category: category, andLimitNumberOfResultsTo: 10)
            result.append(newCategoricalSong)
        }
        result.forEach {
            let playlist = Playlist()
            playlist.name = $0.category.description
            playlist.songs = DataProcessor.shared.getSongsOf(category: $0.category)
            playlists[$0.category] = playlist
        }
        return result
    }
}

extension HomeViewController
{
    override func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return songs.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return songs[keys[section]].count
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        if kind == UICollectionView.elementKindSectionHeader
        {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCVReusableView.identifier, for: indexPath) as! HeaderCVReusableView
            let section = indexPath.section
            let category = keys[section]
            headerView.configure(title: category.description, tagForSeeAllButton: indexPath.section)
            headerView.addTargetToSeeAllButton(target: self, action: #selector(onSeeAllButtonTap(_:)))
            return headerView
        }
        else
        {
            fatalError("No footers were registered")
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterDetailCVCell.identifier, for: indexPath) as! PosterDetailCVCell
        let section = indexPath.section
        let item = indexPath.item
        let category = keys[section]
        let categoricalSongs = songs[category]
        let song = categoricalSongs[item]
        let artistNames = song.getArtistNamesAsString(artistType: nil)
        cell.configureCell(poster: song.coverArt!, title: song.title!, subtitle: artistNames)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let section = indexPath.section
        let item = indexPath.item
        let category = keys[section]
        let categoricalSongs = songs[category]
        let song = categoricalSongs[item]
        if GlobalVariables.shared.currentPlaylist == playlists[category]
        {
            if GlobalVariables.shared.currentSong != song
            {
                GlobalVariables.shared.mainTabController.onPlaylistSongChangeRequest(playlist: playlists[category]!, newSong: song)
            }
        }
        else
        {
            GlobalVariables.shared.mainTabController.onPlaylistSongChangeRequest(playlist: playlists[category]!, newSong: song)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration?
    {
        let section = indexPath.section
        let item = indexPath.item
        let category = keys[section]
        let categoricalSongs = songs[category]
        let song = categoricalSongs[item]
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { [unowned self] _ in
            return createMenu(song: song)
        })
    }
}

extension HomeViewController
{
    @objc func performReload()
    {
        songs = prepareSongs()
        collectionView.reloadData()
        print("Reload performed")
    }
    
    @objc func onRecentlyPlayedListChange()
    {
        guard !GlobalVariables.shared.recentlyPlayedSongNames.isEmpty else
        {
            return
        }
        if didDisplayRecentlyPlayedSongs
        {
            songs[.recentlyPlayed] = DataProcessor.shared.getSongsOf(category: .recentlyPlayed, andLimitNumberOfResultsTo: 10)
            playlists[.recentlyPlayed]!.songs = DataProcessor.shared.getSongsOf(category: .recentlyPlayed)
            collectionView.reloadSections(IndexSet(integer: 0))
        }
        else
        {
            performReload()
            didDisplayRecentlyPlayedSongs = true
        }
    }
    
    @objc func onSeeAllButtonTap(_ sender: UIButton)
    {
        let categoricalVC = CategoricalSongsViewController(style: .grouped)
        let category = keys[sender.tag]
        categoricalVC.category = category
        categoricalVC.delegate = GlobalVariables.shared.mainTabController
        navigationController?.pushViewController(categoricalVC, animated: true)
    }
}
