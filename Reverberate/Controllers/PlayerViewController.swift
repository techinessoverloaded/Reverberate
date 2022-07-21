//
//  SongPlayerViewController.swift
//  Reverberate
//
//  Created by arun-13930 on 21/07/22.
//

import UIKit
import AVKit

class PlayerViewController: UITableViewController
{
    private lazy var backgroundView: UIVisualEffectView = {
        let bView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        return bView
    }()
    
    private lazy var swipeGestureRecognizer: UISwipeGestureRecognizer = {
        let sRecognizer = UISwipeGestureRecognizer()
        sRecognizer.numberOfTouchesRequired = 1
        sRecognizer.direction = .down
        return sRecognizer
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
        stView.font = .preferredFont(forTextStyle: .title2, weight: .semibold)
        stView.numberOfLines = 2
        stView.lineBreakMode = .byTruncatingTail
        stView.isUserInteractionEnabled = true
        stView.textAlignment = .center
        return stView
    }()
    
    private lazy var songSlider: UISlider = {
        let sSlider = UISlider(useAutoLayout: false)
        sSlider.setValue(20, animated: true)
        sSlider.minimumTrackTintColor = .white
        sSlider.maximumTrackTintColor = .systemGray
        return sSlider
    }()
    
    weak var delegate: PlayerDelegate?
    
    weak var avPlayerRef: AVAudioPlayer?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(onCloseButtonTap(_:)))
        view.backgroundColor = .clear
        tableView.backgroundColor = .clear
        tableView.backgroundView = backgroundView
        tableView.allowsSelection = false
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        swipeGestureRecognizer.addTarget(self, action: #selector(onPlayerSwipeAction(_:)))
        view.addGestureRecognizer(swipeGestureRecognizer)
        try! AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        avPlayerRef?.play()
        posterView.image = GlobalVariables.shared.currentSong!.coverArt!
        songTitleView.text = GlobalVariables.shared.currentSong!.title!
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
    }
}

// MARK :- Table View Delegate and Data Source
extension PlayerViewController
{
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let section = indexPath.section
        if section == 0
        {
            return 300
        }
        else if section == 1
        {
            return 50
        }
        else
        {
            return 90
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as! CustomTableViewCell
        let section = indexPath.section
        if section == 0
        {
            cell.addSubViewToContentView(posterView, useAutoLayout: true, useClearBackground: true)
        }
        else if section == 1
        {
            cell.addSubViewToContentView(songTitleView, useAutoLayout: true, useClearBackground: true)
        }
        else
        {
            cell.addSubViewToContentView(songSlider, useAutoLayout: false, useClearBackground: true)
        }
        return cell
    }
}

extension PlayerViewController
{
    @objc func onCloseButtonTap(_ sender: UIBarButtonItem)
    {
        delegate?.onPlayerShrinkRequest()
    }
    
    @objc func onPlayerSwipeAction(_ sender: UIView)
    {
        print("Player swipe action")
        delegate?.onPlayerShrinkRequest()
    }
}

