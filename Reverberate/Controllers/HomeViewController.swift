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
    private let requesterId: Int = Int(NSDate().timeIntervalSince1970 * 1000)
    
    private lazy var songs : [Category : [Song]] = prepareSongs()
    
    private var playlists: [Category: Playlist] = [:]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(view.bounds.width)
        print(collectionView.bounds.width)
    }
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(onShowAlbumNotification(_:)), name: .showAlbumTapNotification, object: nil)
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self, name: .showAlbumTapNotification, object: nil)
    }
    
    private func createMenu(song: Song) -> UIMenu
    {
        return ContextMenuProvider.shared.getSongMenu(song: song, requesterId: requesterId)
    }
    
    private func prepareSongs() -> [Category : [Song]]
    {
        var result: [Category: [Song]] = [:]
        result[.recentlyPlayed] = DataProcessor.shared.getSongsOf(category: .recentlyPlayed, andLimitNumberOfResultsTo: 10)
        result[.starter] = DataProcessor.shared.getSongsOf(category: .starter, andLimitNumberOfResultsTo: 10)
        result[.topCharts] = DataProcessor.shared.getSongsOf(category: .topCharts, andLimitNumberOfResultsTo: 10)
        result[.newReleases] = DataProcessor.shared.getSongsOf(category: .newReleases, andLimitNumberOfResultsTo: 10)
        print(result.keys)
        if !SessionManager.shared.isUserLoggedIn
        {
            let preferredLanguages = UserDefaults.standard.object(forKey: GlobalConstants.preferredLanguages) as! [Int16]
            let preferredGenres = UserDefaults.standard.object(forKey: GlobalConstants.preferredLanguages) as! [Int16]
            preferredLanguages.forEach {
                let category = Category.getCategoryOfLanguage(Language(rawValue: $0)!)!
                result[category] = DataProcessor.shared.getSongsOf(category: category, andLimitNumberOfResultsTo: 10)
            }
            preferredGenres.forEach {
                let category = Category.getCategoryOfGenre(MusicGenre(rawValue: $0)!)!
                result[category] = DataProcessor.shared.getSongsOf(category: category, andLimitNumberOfResultsTo: 10)
            }
        }
        else
        {
            let preferredLanguages = GlobalVariables.shared.currentUser!.preferredLanguages!
            let preferredGenres = GlobalVariables.shared.currentUser!.preferredGenres!
            preferredLanguages.forEach {
                let category = Category.getCategoryOfLanguage(Language(rawValue: $0)!)!
                result[category] = DataProcessor.shared.getSongsOf(category: category, andLimitNumberOfResultsTo: 10)
            }
            preferredGenres.forEach {
                let category = Category.getCategoryOfGenre(MusicGenre(rawValue: $0)!)!
                result[category] = DataProcessor.shared.getSongsOf(category: category, andLimitNumberOfResultsTo: 10)
            }
        }
        result.forEach {
            let playlist = Playlist()
            playlist.name = $0.key.description
            playlist.songs = $0.value
            playlists[$0.key] = playlist
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
        let keys = Array(songs.keys)
        return songs[keys[section]]!.count
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        if kind == UICollectionView.elementKindSectionHeader
        {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCVReusableView.identifier, for: indexPath) as! HeaderCVReusableView
            let section = indexPath.section
            let keys = Array(songs.keys)
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
        let keys = Array(songs.keys)
        let category = keys[section]
        let categoricalSongs = songs[category]!
        let song = categoricalSongs[item]
        let artistNames = song.getArtistNamesAsString(artistType: nil)
        cell.configureCell(poster: song.coverArt!, title: song.title!, subtitle: artistNames)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        collectionView.deselectItem(at: indexPath, animated: true)
        let section = indexPath.section
        let item = indexPath.item
        let keys = Array(songs.keys)
        let category = keys[section]
        let categoricalSongs = songs[category]!
        if GlobalVariables.shared.currentSong != categoricalSongs[item]
        {
            print(categoricalSongs[item])
            GlobalVariables.shared.currentPlaylist = playlists[category]!
            GlobalVariables.shared.currentSong = categoricalSongs[item]
            let indexPathOfRecentlyPlayed = collectionView.indexPathsForVisibleItems.first(where: {
                let ipCategory = keys[$0.section]
                return ipCategory == .recentlyPlayed
            })
            guard let indexPathOfRecentlyPlayed = indexPathOfRecentlyPlayed else
            {
                return
            }
            collectionView.reloadSections(IndexSet(integer: indexPathOfRecentlyPlayed.section))
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration?
    {
        let section = indexPath.section
        let item = indexPath.item
        let keys = Array(songs.keys)
        let category = keys[section]
        let categoricalSongs = songs[category]!
        let song = categoricalSongs[item]
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { [unowned self] _ in
            return createMenu(song: song)
        })
    }
}

extension HomeViewController
{
    @objc func onSeeAllButtonTap(_ sender: UIButton)
    {
        let categoricalVC = CategoricalSongsViewController(style: .grouped)
        let keys = Array(songs.keys)
        let category = keys[sender.tag]
        categoricalVC.category = category
        categoricalVC.delegate = GlobalVariables.shared.mainTabController
        navigationController?.pushViewController(categoricalVC, animated: true)
    }
    
    @objc func onShowAlbumNotification(_ notification: NSNotification)
    {
        guard let receiverId = notification.userInfo?["receiverId"] as? Int, receiverId == requesterId else
        {
            return
        }
        guard let song = notification.userInfo?["song"] as? Song else
        {
            return
        }
        let album = DataProcessor.shared.getAlbumThat(containsSong: song.title!)
        let albumVc = PlaylistViewController(style: .grouped)
        albumVc.delegate = GlobalVariables.shared.mainTabController
        albumVc.playlist = album
        self.navigationController?.pushViewController(albumVc, animated: true)
    }
}
