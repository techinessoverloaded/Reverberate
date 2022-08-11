//
//  MiniPlayerView.swift
//  Reverberate
//
//  Created by arun-13930 on 21/07/22.
//

import UIKit

class MiniPlayerView: UIView
{
    private lazy var playIcon: UIImage = {
        return UIImage(systemName: "play.fill")!
    }()
    
    private lazy var pauseIcon: UIImage = {
        return UIImage(systemName: "pause.fill")!
    }()
    
    private lazy var backgroundView: UIVisualEffectView = {
        let bView = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterial))
        bView.enableAutoLayout()
        return bView
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
    
    private lazy var songTitleView: MarqueeLabel = {
        let stView = MarqueeLabel(useAutoLayout: true)
        stView.textColor = .systemGray
        stView.font = .preferredFont(forTextStyle: .body, weight: .bold)
        stView.text = "No song"
        stView.numberOfLines = 2
        stView.lineBreakMode = .byTruncatingTail
        stView.isUserInteractionEnabled = true
        stView.fadeLength = 10
        return stView
    }()
    
    private lazy var playOrPauseButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .label.withAlphaComponent(0.8)
        config.buttonSize = .mini
        let popButton = UIButton(configuration: config)
        popButton.setImage(playIcon, for: .normal) // or pause.fill
        popButton.enableAutoLayout()
        popButton.isEnabled = false
        return popButton
    }()
    
    private lazy var previousButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "backward.end.fill")!
        config.baseForegroundColor = .label.withAlphaComponent(0.8)
        config.buttonSize = .mini
        let rButton = UIButton(configuration: config)
        rButton.enableAutoLayout()
        rButton.isEnabled = false
        return rButton
    }()
    
    private lazy var nextButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "forward.end.fill")!
        config.baseForegroundColor = .label.withAlphaComponent(0.8)
        config.buttonSize = .mini
        let fButton = UIButton(configuration: config)
        fButton.enableAutoLayout()
        fButton.isEnabled = false
        return fButton
    }()
    
    private lazy var controlsView: UIView = {
        let cView = UIView(useAutoLayout: true)
        cView.backgroundColor = .clear
        return cView
    }()
    
    private lazy var songDurationView: UIProgressView = {
        let sdView = UIProgressView(progressViewStyle: .bar)
        sdView.progressTintColor = UIColor(named: GlobalConstants.techinessColor)!
        sdView.trackTintColor = .separator
        sdView.enableAutoLayout()
        return sdView
    }()
    
    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let tRecognizer = UITapGestureRecognizer()
        tRecognizer.numberOfTapsRequired = 1
        tRecognizer.numberOfTouchesRequired = 1
        return tRecognizer
    }()
    
    private lazy var swipeGestureRecognizer: UISwipeGestureRecognizer = {
        let sRecognizer = UISwipeGestureRecognizer()
        sRecognizer.numberOfTouchesRequired = 1
        sRecognizer.direction = .up
        return sRecognizer
    }()
    
    private var totalSongDuration: Double = 0
    
    weak var delegate: MiniPlayerDelegate?
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        addSubview(backgroundView)
        addSubview(posterView)
        addSubview(songTitleView)
        addSubview(controlsView)
        addSubview(songDurationView)
        controlsView.addSubview(playOrPauseButton)
        controlsView.addSubview(previousButton)
        controlsView.addSubview(nextButton)
        isOpaque = false
        NSLayoutConstraint.activate([
            backgroundView.widthAnchor.constraint(equalTo: widthAnchor),
            backgroundView.heightAnchor.constraint(equalTo: heightAnchor),
            backgroundView.centerXAnchor.constraint(equalTo: centerXAnchor),
            backgroundView.centerYAnchor.constraint(equalTo: centerYAnchor),
            posterView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            posterView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7),
            posterView.widthAnchor.constraint(equalTo: posterView.heightAnchor),
            posterView.centerYAnchor.constraint(equalTo: centerYAnchor),
            songTitleView.leadingAnchor.constraint(equalTo: posterView.trailingAnchor, constant: 10),
            songTitleView.centerYAnchor.constraint(equalTo: centerYAnchor),
            songTitleView.trailingAnchor.constraint(equalTo: controlsView.leadingAnchor, constant: -10),
            controlsView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.35),
            controlsView.heightAnchor.constraint(equalTo: heightAnchor),
            controlsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            previousButton.trailingAnchor.constraint(equalTo: playOrPauseButton.leadingAnchor, constant: -8),
            previousButton.centerYAnchor.constraint(equalTo: controlsView.centerYAnchor),
            playOrPauseButton.centerYAnchor.constraint(equalTo: controlsView.centerYAnchor),
            playOrPauseButton.centerXAnchor.constraint(equalTo: controlsView.centerXAnchor),
            nextButton.leadingAnchor.constraint(equalTo: playOrPauseButton.trailingAnchor, constant: 8),
            nextButton.centerYAnchor.constraint(equalTo: controlsView.centerYAnchor),
            songDurationView.widthAnchor.constraint(equalTo: widthAnchor),
            songDurationView.heightAnchor.constraint(equalToConstant: 2),
            songDurationView.centerXAnchor.constraint(equalTo: centerXAnchor),
            songDurationView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        playOrPauseButton.addTarget(self, action: #selector(onPlayOrPauseButtonTap(_:)), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(onNextButtonTap(_:)), for: .touchUpInside)
        previousButton.addTarget(self, action: #selector(onPreviousButtonTap(_:)), for: .touchUpInside)
        addTopCornerRadius(radius: 20)
        tapRecognizer.addTarget(self, action: #selector(onMiniPlayerViewTap(_:)))
        self.addGestureRecognizer(tapRecognizer)
        swipeGestureRecognizer.addTarget(self, action: #selector(onMiniPlayerViewSwipe(_:)))
        self.addGestureRecognizer(swipeGestureRecognizer)
        print(playOrPauseButton.isEnabled)
    }
    
    required init(coder: NSCoder)
    {
        fatalError("Not initialized")
    }
    
    func setDetails()
    {
        guard let song = GlobalVariables.shared.currentSong else {
            songTitleView.textColor = .systemGray
            songTitleView.text = "No song"
            posterView.image = UIImage(named: "glassmorphic_bg")!
            playOrPauseButton.isEnabled = false
            playOrPauseButton.setImage(playIcon, for: .normal)
            return
        }
        posterView.image = song.coverArt!
        songTitleView.text = song.title!
        songTitleView.textColor = .label.withAlphaComponent(0.8)
        playOrPauseButton.isEnabled = true
        totalSongDuration = song.duration!
    }
    
    func setPlaying(shouldPlaySong: Bool)
    {
        setDetails()
        if shouldPlaySong
        {
            playOrPauseButton.setImage(pauseIcon, for: .normal)
        }
        else
        {
            playOrPauseButton.setImage(playIcon, for: .normal)
        }
    }
    
    func updateSongDurationView(newValue: Float)
    {
        let normalizedDuration = Float(Double(newValue) / totalSongDuration)
        songDurationView.setProgress(normalizedDuration, animated: true)
    }
}

extension MiniPlayerView
{
    @objc func onPlayOrPauseButtonTap(_ sender: UIButton)
    {
        if sender.image(for: .normal)!.pngData() == playIcon.pngData()
        {
            print("Gonna Play")
            delegate?.onMiniPlayerPlayButtonTap()
            sender.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
        else
        {
            print("Gonna Pause")
            delegate?.onMiniPlayerPauseButtonTap()
            sender.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }
    
    @objc func onPreviousButtonTap(_ sender: UIButton)
    {
        print("Previous")
        delegate?.onMiniPlayerPreviousButtonTap()
    }
    
    @objc func onNextButtonTap(_ sender: UIButton)
    {
        print("Next")
        delegate?.onMiniPlayerNextButtonTap()
    }
    
    @objc func onMiniPlayerViewTap(_ sender: UIView)
    {
        if GlobalVariables.shared.currentSong != nil
        {
            delegate?.onPlayerExpansionRequest()
        }
    }
    
    @objc func onMiniPlayerViewSwipe(_ sender: UIView)
    {
        if GlobalVariables.shared.currentSong != nil
        {
            delegate?.onPlayerExpansionRequest()
        }
    }
}
