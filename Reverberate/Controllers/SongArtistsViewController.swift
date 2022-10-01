//
//  SongArtistsViewController.swift
//  Reverberate
//
//  Created by arun-13930 on 25/07/22.
//

import UIKit

class SongArtistsViewController: UICollectionViewController
{
    private let requesterId: Int = 6
    
    private lazy var backgroundView: UIVisualEffectView = {
        let bView = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterial))
        return bView
    }()
    
    private lazy var artists: [ArtistType : [Artist]] = {
        let song = GlobalVariables.shared.currentSong!
        var result: [ArtistType : [Artist]] = [:]
        for type in ArtistType.allCases
        {
            result[type] = song.getArtists(ofType: type)
        }
        return result
    }()
    
    weak var delegate: SongArtistsViewDelegate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(onCloseButtonTap(_:)))
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Contributing Artists"
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.label.withAlphaComponent(0.8),
            NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: .largeTitle, weight: .bold)
        ]
        view.backgroundColor = .clear
        collectionView.backgroundColor = .clear
        collectionView.backgroundView = backgroundView
        collectionView.backgroundColor = .clear
        collectionView.register(ArtistCVCell.self, forCellWithReuseIdentifier: ArtistCVCell.identifier)
        collectionView.register(HeaderCVReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCVReusableView.identifier)
    }

    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        LifecycleLogger.viewDidAppearLog(self)
        NotificationCenter.default.setObserver(self, selector: #selector(onAddArtistToFavouritesNotification(_:)), name: .addArtistToFavouritesNotification, object: nil)
        NotificationCenter.default.setObserver(self, selector: #selector(onRemoveArtistFromFavouritesNotification(_:)), name: .removeArtistFromFavouritesNotification, object: nil)
        NotificationCenter.default.setObserver(self, selector: #selector(onLoginRequestNotification(_:)), name: .loginRequestNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        LifecycleLogger.viewDidDisappearLog(self)
        NotificationCenter.default.removeObserver(self, name: .addArtistToFavouritesNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: .removeArtistFromFavouritesNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: .loginRequestNotification, object: nil)
        super.viewDidDisappear(animated)
    }
    
    deinit
    {
        LifecycleLogger.deinitLog(self)
    }
    
    private func createArtistMenu(artist: Artist) -> UIMenu
    {
        return ContextMenuProvider.shared.getArtistMenu(artist: artist, requesterId: requesterId)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { [unowned self] _ in
            collectionViewLayout.invalidateLayout()
        })
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        let sectionAsInt16 = Int16(section)
        return artists[ArtistType(rawValue: sectionAsInt16)!]!.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        if kind == UICollectionView.elementKindSectionHeader
        {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCVReusableView.identifier, for: indexPath) as! HeaderCVReusableView
            let section = Int16(indexPath.section)
            headerView.configure(title: ArtistType(rawValue: section)!.description, shouldShowSeeAllButton: false, headerFontColorOpacity: 0.8)
            return headerView
        }
        else
        {
            fatalError("No footers were registered")
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtistCVCell.identifier, for: indexPath) as! ArtistCVCell
        let section = Int16(indexPath.section)
        let item = indexPath.item
        let artist = artists[ArtistType(rawValue: section)!]![item]
        let artistName = NSAttributedString(string: artist.name!)
        let artistPhoto = artist.photo!
        cell.configureCell(artistPicture: artistPhoto, attributedArtistName: artistName)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let section = Int16(indexPath.section)
        let item = indexPath.item
        let artist = artists[ArtistType(rawValue: section)!]![item]
        self.dismiss(animated: true)
        delegate?.onArtistDetailViewRequest(artist: artist)
    }
    
    override func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration?
    {
        let section = Int16(indexPath.section)
        let item = indexPath.item
        let artist = artists[ArtistType(rawValue: section)!]![item]
        return UIContextMenuConfiguration(identifier: indexPath as NSCopying, previewProvider: nil, actionProvider: { [unowned self] _ in
            return createArtistMenu(artist: artist)
        })
    }
    
    override func collectionView(_ collectionView: UICollectionView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview?
    {
        guard let indexPath = configuration.identifier as? IndexPath else
        {
            return nil
        }
        let cell = collectionView.cellForItem(at: indexPath)!
        let previewParameters = UIPreviewParameters()
        previewParameters.backgroundColor = .clear
        return UITargetedPreview(view: cell.contentView, parameters: previewParameters)
    }
    
    override func collectionView(_ collectionView: UICollectionView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview?
    {
        guard let indexPath = configuration.identifier as? IndexPath else
        {
            return nil
        }
        let cell = collectionView.cellForItem(at: indexPath)!
        let previewParameters = UIPreviewParameters()
        previewParameters.backgroundColor = .clear
        return UITargetedPreview(view: cell.contentView, parameters: previewParameters)
    }
    
    override func collectionView(_ collectionView: UICollectionView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating)
    {
        guard let indexPath = configuration.identifier as? IndexPath else
        {
            return
        }
        animator.preferredCommitStyle = .pop
        let section = Int16(indexPath.section)
        let item = indexPath.item
        let artist = artists[ArtistType(rawValue: section)!]![item]
        animator.addAnimations { [unowned self] in
            self.dismiss(animated: false)
            delegate?.onArtistDetailViewRequest(artist: artist)
        }
    }
}

extension SongArtistsViewController
{
    @objc func onCloseButtonTap(_ sender: UIBarButtonItem)
    {
        self.dismiss(animated: true)
    }
    
    @objc func onAddArtistToFavouritesNotification(_ notification: NSNotification)
    {
        guard let artist = notification.userInfo?["artist"] as? Artist else
        {
            return
        }
        GlobalVariables.shared.mainTabController.onAddArtistToFavouritesNotification(NSNotification(name: .addArtistToFavouritesNotification, object: nil, userInfo: ["receiverId" : GlobalVariables.shared.mainTabController.requesterId, "artist" : artist]))
    }
    
    @objc func onRemoveArtistFromFavouritesNotification(_ notification: NSNotification)
    {
        guard let artist = notification.userInfo?["artist"] as? Artist else
        {
            return
        }
        GlobalVariables.shared.mainTabController.onRemoveArtistFromFavouritesNotification(NSNotification(name:.removeArtistFromFavouritesNotification, object: nil, userInfo: ["receiverId" : GlobalVariables.shared.mainTabController.requesterId, "artist" : artist]))
    }
    
    @objc func onLoginRequestNotification(_ notification: NSNotification)
    {
        self.dismiss(animated: true, completion: { [unowned self] in
            delegate?.onLoginRequest()
        })
    }
}
