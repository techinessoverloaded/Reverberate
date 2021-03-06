//
//  SongPlayerViewController.swift
//  Reverberate
//
//  Created by arun-13930 on 21/07/22.
//

import UIKit

class PlayerViewController: UITableViewController
{
    private lazy var playIcon: UIImage = {
        return UIImage(systemName: "play.fill")!
    }()
    
    private lazy var pauseIcon: UIImage = {
        return UIImage(systemName: "pause.fill")!
    }()
    
    private lazy var repeatIcon: UIImage = {
        return UIImage(systemName: "repeat")!
    }()
    
    private lazy var repeatOneIcon: UIImage = {
        return UIImage(systemName: "repeat.1")!
    }()
    
    private lazy var heartIcon: UIImage = {
        return UIImage(systemName: "heart")!
    }()
    
    private lazy var heartFilledIcon: UIImage = {
        return UIImage(systemName: "heart.fill")!
    }()
    
    private lazy var buttonSize: UIButton.Configuration.Size = {
        if isIpad
        {
            return UIButton.Configuration.Size.large
        }
        else
        {
            return UIButton.Configuration.Size.small
        }
    }()
    
    private lazy var backgroundView: UIVisualEffectView = {
        let bView = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterial))
        return bView
    }()
    
    private lazy var swipeGestureRecognizer: UISwipeGestureRecognizer = {
        let sRecognizer = UISwipeGestureRecognizer()
        sRecognizer.numberOfTouchesRequired = 1
        sRecognizer.direction = .down
        return sRecognizer
    }()
    
    private lazy var albumTitleView: UILabel = {
        let atView = UILabel(useAutoLayout: true)
        atView.textColor = .label
        atView.font = .preferredFont(forTextStyle: .title1, weight: .bold)
        atView.numberOfLines = 2
        atView.lineBreakMode = .byTruncatingTail
        atView.isUserInteractionEnabled = true
        atView.textAlignment = .center
        return atView
    }()
    
    private lazy var posterView: UIImageView = {
        let pView = UIImageView(useAutoLayout: true)
        pView.isUserInteractionEnabled = true
        pView.contentMode = .scaleAspectFill
        pView.image = UIImage(named: "glassmorphic_bg")!
        pView.layer.cornerRadius = 10
        pView.layer.cornerCurve = .continuous
        pView.clipsToBounds = true
        return pView
    }()
    
    private lazy var songTitleView: UILabel = {
        let stView = UILabel(useAutoLayout: true)
        stView.textColor = .label
        stView.font = .preferredFont(forTextStyle: .title2, weight: .bold)
        stView.numberOfLines = 2
        stView.lineBreakMode = .byTruncatingTail
        stView.isUserInteractionEnabled = true
        stView.textAlignment = .center
        return stView
    }()
    
    private lazy var songArtistsView: UILabel = {
        let stView = UILabel(useAutoLayout: true)
        stView.textColor = .label
        stView.font = .preferredFont(forTextStyle: .body, weight: .semibold)
        stView.numberOfLines = 2
        stView.lineBreakMode = .byTruncatingTail
        stView.isUserInteractionEnabled = true
        stView.textAlignment = .center
        return stView
    }()
    
    private lazy var songSlider: UISlider = {
        let sSlider = UISlider(useAutoLayout: true)
        sSlider.setValue(20, animated: true)
        sSlider.minimumTrackTintColor = UIColor(named: GlobalConstants.techinessColor)!
        sSlider.maximumTrackTintColor = .systemGray
        sSlider.thumbTintColor = UIColor(named: GlobalConstants.techinessColor)!
        sSlider.isContinuous = true
        return sSlider
    }()
    
    private lazy var minimumDurationLabel: UILabel = {
        let mDLabel = UILabel(useAutoLayout: true)
        mDLabel.textColor = .secondaryLabel
        mDLabel.font = .preferredFont(forTextStyle: .footnote, weight: .semibold)
        mDLabel.textAlignment = .left
        mDLabel.text = "00:00"
        return mDLabel
    }()
    
    private lazy var maximumDurationLabel: UILabel = {
        let maDLabel = UILabel(useAutoLayout: true)
        maDLabel.textColor = .secondaryLabel
        maDLabel.font = .preferredFont(forTextStyle: .footnote, weight: .semibold)
        maDLabel.textAlignment = .right
        maDLabel.text = "00:00"
        return maDLabel
    }()
    
    private lazy var durationView: UIView = {
        let dView = UIView(useAutoLayout: true)
        dView.backgroundColor = .clear
        return dView
    }()
    
    private lazy var playOrPauseButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .label
        config.buttonSize = buttonSize
        let popButton = UIButton(configuration: config)
        popButton.setImage(playIcon, for: .normal)
        popButton.enableAutoLayout()
        return popButton
    }()
    
    private lazy var rewindButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "gobackward.10")!
        config.baseForegroundColor = .label
        config.buttonSize = buttonSize
        let rButton = UIButton(configuration: config)
        rButton.enableAutoLayout()
        return rButton
    }()
    
    private lazy var forwardButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "goforward.10")!
        config.baseForegroundColor = .label
        config.buttonSize = buttonSize
        let fButton = UIButton(configuration: config)
        fButton.enableAutoLayout()
        return fButton
    }()
    
    private lazy var previousButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "backward.end.alt.fill")!
        config.baseForegroundColor = .label
        config.buttonSize = buttonSize
        let pButton = UIButton(configuration: config)
        pButton.enableAutoLayout()
        pButton.isEnabled = false
        return pButton
    }()
    
    private lazy var nextButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "forward.end.alt.fill")!
        config.baseForegroundColor = .label
        config.buttonSize = buttonSize
        let nButton = UIButton(configuration: config)
        nButton.enableAutoLayout()
        nButton.isEnabled = false
        return nButton
    }()
    
    private lazy var shuffleButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "shuffle")!
        config.baseForegroundColor = .label
        config.buttonSize = buttonSize
        let sButton = UIButton(configuration: config)
        sButton.enableAutoLayout()
        sButton.isEnabled = false
        return sButton
    }()
    
    private lazy var loopButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .label
        config.buttonSize = buttonSize
        let lButton = UIButton(configuration: config)
        lButton.enableAutoLayout()
        lButton.setImage(repeatIcon, for: .normal)
        return lButton
    }()
    
    private lazy var controlsView: UIView = {
        let cView = UIView(useAutoLayout: true)
        cView.backgroundColor = .clear
        return cView
    }()
    
    private lazy var addToPlaylistsButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .label
        config.buttonSize = .large
        let atpButton = UIButton(configuration: config)
        atpButton.setImage(UIImage(systemName: "text.badge.plus")!, for: .normal)
        atpButton.isEnabled = false
        return atpButton
    }()
    
    private lazy var favouriteButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .label
        config.buttonSize = .large
        let favButton = UIButton(configuration: config)
        favButton.setImage(heartIcon, for: .normal)
        return favButton
    }()
    
    weak var delegate: PlayerDelegate?
    
    override func loadView()
    {
        super.loadView()
        durationView.addSubview(minimumDurationLabel)
        durationView.addSubview(maximumDurationLabel)
        controlsView.addSubview(shuffleButton)
        controlsView.addSubview(previousButton)
        controlsView.addSubview(rewindButton)
        controlsView.addSubview(playOrPauseButton)
        controlsView.addSubview(forwardButton)
        controlsView.addSubview(nextButton)
        controlsView.addSubview(loopButton)
        NSLayoutConstraint.activate([
            minimumDurationLabel.leadingAnchor.constraint(equalTo: durationView.leadingAnchor),
            minimumDurationLabel.centerYAnchor.constraint(equalTo: durationView.centerYAnchor),
            minimumDurationLabel.widthAnchor.constraint(equalTo: durationView.widthAnchor, multiplier: 0.5),
            maximumDurationLabel.trailingAnchor.constraint(equalTo: durationView.trailingAnchor),
            maximumDurationLabel.centerYAnchor.constraint(equalTo: durationView.centerYAnchor),
            maximumDurationLabel.widthAnchor.constraint(equalTo: durationView.widthAnchor, multiplier: 0.5),
            shuffleButton.trailingAnchor.constraint(equalTo: previousButton.leadingAnchor, constant: -8),
            shuffleButton.centerYAnchor.constraint(equalTo: controlsView.centerYAnchor),
            previousButton.centerYAnchor.constraint(equalTo: controlsView.centerYAnchor),
            previousButton.trailingAnchor.constraint(equalTo: rewindButton.leadingAnchor, constant: -8),
            rewindButton.centerYAnchor.constraint(equalTo: controlsView.centerYAnchor),
            rewindButton.trailingAnchor.constraint(equalTo: playOrPauseButton.leadingAnchor, constant: -8),
            playOrPauseButton.centerXAnchor.constraint(equalTo: controlsView.centerXAnchor),
            playOrPauseButton.centerYAnchor.constraint(equalTo: controlsView.centerYAnchor),
            forwardButton.leadingAnchor.constraint(equalTo: playOrPauseButton.trailingAnchor, constant: 8),
            forwardButton.centerYAnchor.constraint(equalTo: controlsView.centerYAnchor),
            nextButton.leadingAnchor.constraint(equalTo: forwardButton.trailingAnchor, constant: 8),
            nextButton.centerYAnchor.constraint(equalTo: controlsView.centerYAnchor),
            loopButton.leadingAnchor.constraint(equalTo: nextButton.trailingAnchor, constant: 8),
            loopButton.centerYAnchor.constraint(equalTo: controlsView.centerYAnchor),
        ])
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrowtriangle.down.circle.fill")!.withTintColor(.systemGray, renderingMode: .alwaysTemplate), style: .plain, target: self, action: #selector(onMinimizeButtonTap(_:)))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: addToPlaylistsButton),
            UIBarButtonItem(customView: favouriteButton)
        ]
        view.backgroundColor = .clear
        tableView.backgroundColor = .clear
        tableView.backgroundView = backgroundView
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        swipeGestureRecognizer.addTarget(self, action: #selector(onPlayerSwipeAction(_:)))
        navigationController?.view.addGestureRecognizer(swipeGestureRecognizer)
        navigationController?.view.isUserInteractionEnabled = true
        playOrPauseButton.addTarget(self, action: #selector(onPlayOrPauseButtonTap(_:)), for: .touchUpInside)
        rewindButton.addTarget(self, action: #selector(onRewindButtonTap(_:)), for: .touchUpInside)
        forwardButton.addTarget(self, action: #selector(onForwardButtonTap(_:)), for: .touchUpInside)
        previousButton.addTarget(self, action: #selector(onPreviousButtonTap(_:)), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(onNextButtonTap(_:)), for: .touchUpInside)
        shuffleButton.addTarget(self, action: #selector(onShuffleButtonTap(_:)), for: .touchUpInside)
        loopButton.addTarget(self, action: #selector(onLoopButtonTap(_:)), for: .touchUpInside)
        songSlider.addTarget(self, action: #selector(onSongSliderValueChange(_:)), for: .valueChanged)
        favouriteButton.addTarget(self, action: #selector(onFavouriteButtonTap(_:)), for: .touchUpInside)
        addToPlaylistsButton.addTarget(self, action: #selector(onAddToPlaylistsButtonTap(_:)), for: .touchUpInside)
        songSlider.minimumValue = 0.0
        songSlider.maximumValue = Float(GlobalVariables.shared.avAudioPlayer.duration)
        setDetails()
        updateTime()
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimerFire(_:)), userInfo: nil, repeats: true)
    }
    
    func setPlaying(shouldPlaySongFromBeginning: Bool, isSongPaused: Bool? = nil)
    {
        if shouldPlaySongFromBeginning
        {
            print("Should Play from Beginning")
            onPlayOrPauseButtonTap(playOrPauseButton)
        }
        else
        {
            guard let isSongPaused = isSongPaused else {
                return
            }
            if isSongPaused
            {
                playOrPauseButton.setImage(playIcon, for: .normal)
            }
            else
            {
                playOrPauseButton.setImage(pauseIcon, for: .normal)
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.scrollToRow(at: IndexPath(item: 4, section: 2), at: .bottom, animated: true)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        coordinator.animate(alongsideTransition: {
            _ in
        }, completion: { [unowned self] _ in
            self.tableView.scrollToRow(at: IndexPath(item: 4, section: 2), at: .bottom, animated: true)
        })
    }
    
    func setDetails()
    {
        let song = GlobalVariables.shared.currentSong!
        albumTitleView.text = song.albumName!
        posterView.image = song.coverArt!
        songTitleView.text = song.title!
        songArtistsView.text = song.getArtistNamesAsString()
        let songDuration = Float(GlobalVariables.shared.avAudioPlayer.duration)
        let seconds = String(format: "%02d", Int(songDuration) % 60)
        let minutes = String(format: "%02d", Int(songDuration) / 60)
        maximumDurationLabel.text = "\(minutes):\(seconds)"
    }
    
    func updateTime()
    {
        let currentTime = Float(GlobalVariables.shared.avAudioPlayer.currentTime)
        songSlider.value = currentTime
        let seconds = String(format: "%02d", Int(currentTime) % 60)
        let minutes = String(format: "%02d", Int(currentTime) / 60)
        minimumDurationLabel.text = "\(minutes):\(seconds)"
    }
}

// MARK :- Table View Delegate and Data Source
extension PlayerViewController
{
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 2
        {
            return 5
        }
        else
        {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let section = indexPath.section
        let item = indexPath.item
        if section == 0
        {
            return 70
        }
        else if section == 1
        {
            return 300
        }
        else if section == 2
        {
            if item == 3
            {
                return 10
            }
            else if item == 4
            {
                return 100
            }
            else
            {
                return 50
            }
        }
        else
        {
            return 50
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as! CustomTableViewCell
        let section = indexPath.section
        let item = indexPath.item
        if section == 0
        {
            cell.addSubViewToContentView(albumTitleView, useAutoLayout: true, useClearBackground: true)
        }
        else if section == 1
        {
            cell.addSubViewToContentView(posterView, useAutoLayout: true, useClearBackground: true)
        }
        else if section == 2
        {
            if item == 0
            {
                cell.addSubViewToContentView(songTitleView, useAutoLayout: true, useClearBackground: true)
            }
            else if item == 1
            {
                cell.addSubViewToContentView(songArtistsView, useAutoLayout: true, useClearBackground: true)
            }
            else if item == 2
            {
                cell.addSubViewToContentView(songSlider, useAutoLayout: true, useMultiplierForWidth: 0.95, useClearBackground: true)
            }
            else if item == 3
            {
                cell.addSubViewToContentView(durationView, useAutoLayout: true, useMultiplierForWidth: 0.95, useClearBackground: true)
            }
            else
            {
                cell.addSubViewToContentView(controlsView, useAutoLayout: true, useMultiplierForWidth: 0.95, useClearBackground: true)
            }
        }
        else
        {
            
        }
        return cell
    }
}

extension PlayerViewController
{
    @objc func onTimerFire(_ timer: Timer)
    {
        updateTime()
    }
    
    @objc func onFavouriteButtonTap(_ sender: UIButton)
    {
        if sender.image(for: .normal)!.pngData() == heartIcon.pngData()
        {
            delegate?.onFavouriteButtonTap(shouldMakeAsFavourite: true)
            sender.setImage(heartFilledIcon, for: .normal)
            sender.configuration!.baseForegroundColor = .systemPink
        }
        else
        {
            delegate?.onFavouriteButtonTap(shouldMakeAsFavourite: false)
            sender.setImage(heartIcon, for: .normal)
            sender.configuration!.baseForegroundColor = .label
        }
    }
    
    @objc func onAddToPlaylistsButtonTap(_ sender: UIButton)
    {
        if sender.configuration!.baseForegroundColor == .label
        {
            delegate?.onAddToPlaylistsButtonTap(shouldAddToPlaylists: true)
            sender.configuration!.baseForegroundColor = UIColor(named: GlobalConstants.darkGreenColor)!
        }
        else
        {
            delegate?.onAddToPlaylistsButtonTap(shouldAddToPlaylists: false)
            sender.configuration!.baseForegroundColor = .label
        }
    }
    
    @objc func onPlayOrPauseButtonTap(_ sender: UIButton)
    {
        if sender.image(for: .normal)!.pngData() == playIcon.pngData()
        {
            print("Gonna Play")
            delegate?.onPlayButtonTap()
            sender.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
        else
        {
            print("Gonna Pause")
            delegate?.onPauseButtonTap()
            sender.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }
    
    @objc func onRewindButtonTap(_ sender: UIButton)
    {
        print("Rewind")
        delegate?.onRewindButtonTap()
        updateTime()
    }
    
    @objc func onForwardButtonTap(_ sender: UIButton)
    {
        print("Forward")
        delegate?.onForwardButtonTap()
        updateTime()
    }
    
    @objc func onPreviousButtonTap(_ sender: UIButton)
    {
        print("Previous")
        delegate?.onPreviousButtonTap()
    }
    
    @objc func onNextButtonTap(_ sender: UIButton)
    {
        print("Next")
        delegate?.onNextButtonTap()
    }
    
    @objc func onShuffleButtonTap(_ sender: UIButton)
    {
        print("Shuffle")
        delegate?.onShuffleButtonTap()
    }
    
    @objc func onLoopButtonTap(_ sender: UIButton)
    {
        if sender.image(for: .normal)!.pngData() == repeatIcon.pngData()
        {
            if sender.configuration?.baseForegroundColor == .label
            {
                print("Loop Once")
                delegate?.onLoopButtonTap(loopMode: 1)
                sender.configuration?.baseForegroundColor = UIColor(named: GlobalConstants.darkGreenColor)!
                sender.setImage(repeatOneIcon, for: .normal)
            }
            else if sender.configuration?.baseForegroundColor == UIColor(named: GlobalConstants.darkGreenColor)!
            {
                print("No Loop")
                delegate?.onLoopButtonTap(loopMode: 0)
                sender.configuration?.baseForegroundColor = .label
            }
        }
        else
        {
            print("Loop")
            delegate?.onLoopButtonTap(loopMode: -1)
            sender.setImage(repeatIcon, for: .normal)
        }
    }
    
    @objc func onSongSliderValueChange(_ sender: UISlider)
    {
        delegate?.onSongSeekRequest(songPosition: Double(sender.value))
    }
    
    @objc func onMinimizeButtonTap(_ sender: UIBarButtonItem)
    {
        delegate?.onPlayerShrinkRequest()
    }
    
    @objc func onPlayerSwipeAction(_ sender: UIView)
    {
        print("Player swipe action")
        delegate?.onPlayerShrinkRequest()
    }
}

