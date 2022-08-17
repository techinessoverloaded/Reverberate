//
//  TabView.swift
//  Reverberate
//
//  Created by arun-13930 on 16/08/22.
//

import UIKit

class LibraryTabView: UIView
{
    enum Tab
    {
        case favourites, playlists
    }
    
    private lazy var favouritesButton: UIButton = {
        let fButton = UIButton(useAutoLayout: true)
        fButton.setTitleColor(.label, for: .normal)
        fButton.setTitle("Favourites", for: .normal)
        return fButton
    }()
    
    private lazy var playlistsButton: UIButton = {
        let pButton = UIButton(useAutoLayout: true)
        pButton.setTitleColor(.label, for: .normal)
        pButton.setTitle("Playlists", for: .normal)
        return pButton
    }()
    
    private lazy var indicatorView: UIView = {
        let iView = UIView(useAutoLayout: true)
        iView.backgroundColor = UIColor(named: GlobalConstants.techinessColor)!
        iView.layer.masksToBounds = true
        iView.layer.cornerRadius = 10
        return iView
    }()
    
    private lazy var indicatorViewTopFavAnchor: NSLayoutConstraint = indicatorView.topAnchor.constraint(equalTo: favouritesButton.bottomAnchor)
    
    private lazy var indicatorViewCenXFavAnchor: NSLayoutConstraint = indicatorView.centerXAnchor.constraint(equalTo: favouritesButton.centerXAnchor)
    
    private lazy var indicatorViewTopPlayAnchor: NSLayoutConstraint = indicatorView.topAnchor.constraint(equalTo: playlistsButton.bottomAnchor)
    
    private lazy var indicatorViewCenXPlayAnchor: NSLayoutConstraint = indicatorView.centerXAnchor.constraint(equalTo: playlistsButton.centerXAnchor)
    
    weak var delegate: LibraryTabViewDelegate?
    
    var selectedTab: Tab = .favourites
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        backgroundColor = .systemGroupedBackground
        addSubview(favouritesButton)
        addSubview(playlistsButton)
        addSubview(indicatorView)
        NSLayoutConstraint.activate([
            favouritesButton.heightAnchor.constraint(equalTo: heightAnchor, constant: -20),
            favouritesButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            favouritesButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            playlistsButton.heightAnchor.constraint(equalTo: heightAnchor, constant: -20),
            playlistsButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            playlistsButton.leadingAnchor.constraint(equalTo: favouritesButton.trailingAnchor),
            indicatorView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            indicatorView.heightAnchor.constraint(equalToConstant: 4),
            indicatorViewTopFavAnchor,
            indicatorViewCenXFavAnchor
        ])
        favouritesButton.addTarget(self, action: #selector(onFavouritesTabTap(_:)), for: .touchUpInside)
        playlistsButton.addTarget(self, action: #selector(onPlaylistsTabTap(_:)), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateIndicator(forTab tab: Tab)
    {
        switch tab
        {
        case .favourites:
            UIView.animate(withDuration: 0.2)
            {
                [unowned self] in
                indicatorViewCenXPlayAnchor.isActive = false
                indicatorViewTopPlayAnchor.isActive = false
                indicatorViewTopFavAnchor.isActive = true
                indicatorViewCenXFavAnchor.isActive = true
            }
            selectedTab = .favourites
        case .playlists:
            UIView.animate(withDuration: 0.2)
            {
                [unowned self] in
                indicatorViewTopFavAnchor.isActive = false
                indicatorViewCenXFavAnchor.isActive = false
                indicatorViewCenXPlayAnchor.isActive = true
                indicatorViewTopPlayAnchor.isActive = true
            }
            selectedTab = .playlists
        }
    }
}

extension LibraryTabView
{
    @objc func onFavouritesTabTap(_ sender: UIButton)
    {
        updateIndicator(forTab: .favourites)
        delegate?.onFavouritesTabTap(self)
    }
    
    @objc func onPlaylistsTabTap(_ sender: UIButton)
    {
        updateIndicator(forTab: .playlists)
        delegate?.onPlaylistsTabTap(self)
    }
}
