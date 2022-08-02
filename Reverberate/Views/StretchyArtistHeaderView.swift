//
//  StretchyTableHeaderView.swift
//  Reverberate
//
//  Created by arun-13930 on 29/07/22.
//

import Foundation
import UIKit

class StretchyArtistHeaderView: UIView
{
    private lazy var backgroundViewHeight: NSLayoutConstraint = backgroundView.heightAnchor.constraint(equalTo: containerView.heightAnchor)
    
    private lazy var backgroundViewBottom: NSLayoutConstraint = backgroundView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
    
    private lazy var containerViewHeight: NSLayoutConstraint = containerView.heightAnchor.constraint(equalTo: self.heightAnchor)
    
    private lazy var containerView: UIView = UIView(useAutoLayout: true)
    
    private lazy var artistPhotoView: UIImageView = {
        let apView = UIImageView(useAutoLayout: true)
        apView.clipsToBounds = true
        apView.contentMode = .scaleAspectFill
        apView.layer.cornerCurve = .continuous
        apView.layer.cornerRadius = 10
        apView.layer.borderColor = UIColor.white.cgColor//UIColor(named: GlobalConstants.techinessColor)!.cgColor
        apView.layer.borderWidth = 4
        return apView
    }()
    
    private lazy var backgroundView: UIImageView = {
        let bView = UIImageView(useAutoLayout: true)
        bView.clipsToBounds = true
        bView.contentMode = .scaleAspectFill
        bView.image = UIImage(named: "dark_gradient_bg")!
        return bView
    }()
    
    private lazy var overlayView: UIView = {
        let olView = UIView()
        olView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        olView.backgroundColor = .black
        olView.alpha = 0
        olView.clipsToBounds = true
        olView.layer.cornerCurve = .continuous
        olView.layer.cornerRadius = 10
        return olView
    }()
    
    private lazy var artistNameView: UILabel = {
        let anView = UILabel(useAutoLayout: true)
        anView.textColor = .white
        anView.font = .systemFont(ofSize: 28, weight: .bold)
        anView.textAlignment = .center
        anView.numberOfLines = 2
        return anView
    }()
    
    private lazy var artistTypeView: UILabel = {
        let atView = UILabel(useAutoLayout: true)
        atView.textColor = .white
        atView.font = .preferredFont(forTextStyle: .subheadline, weight: .semibold)
        atView.textAlignment = .center
        atView.numberOfLines = 2
        return atView
    }()
    
    private lazy var playButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor(named: GlobalConstants.darkGreenColor)!
        config.baseForegroundColor = .white
        config.image = UIImage(systemName: "play.fill")
        config.title = "Play All"
        config.imagePadding = 10
        config.cornerStyle = .capsule
        config.buttonSize = .small
//        let pButton = UIButton(type: .roundedRect)
//        pButton.backgroundColor = UIColor(named: GlobalConstants.darkGreenColor)!
//        pButton.tintColor = .white
//        pButton.setTitle("Play All", for: .normal)
//        pButton.setImage(playIcon, for: .normal)
//        pButton.layer.cornerRadius = 20
        let pButton = UIButton(configuration: config)
        pButton.enableAutoLayout()
        pButton.clipsToBounds = true
        return pButton
    }()
    
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    func setViewConstraints()
    {
        self.addSubview(containerView)
        containerView.addSubview(backgroundView)
        artistPhotoView.addSubview(overlayView)
        backgroundView.addSubview(artistPhotoView)
        backgroundView.addSubview(artistNameView)
        backgroundView.addSubview(artistTypeView)
        backgroundView.addSubview(playButton)
        
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            self.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            self.heightAnchor.constraint(equalTo: containerView.heightAnchor),
            containerViewHeight,
            containerView.widthAnchor.constraint(equalTo: backgroundView.widthAnchor),
            backgroundViewHeight,
            backgroundViewBottom,
            artistPhotoView.widthAnchor.constraint(equalToConstant: 150),
            artistPhotoView.heightAnchor.constraint(equalTo: artistPhotoView.widthAnchor),
            artistPhotoView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            artistPhotoView.bottomAnchor.constraint(equalTo: artistNameView.topAnchor, constant: -10),            //artistPhotoView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor, constant: -30),
            //artistNameView.topAnchor.constraint(equalTo: artistPhotoView.bottomAnchor, constant: 20),
            artistNameView.bottomAnchor.constraint(equalTo: artistTypeView.topAnchor, constant: -10),
            artistNameView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            artistNameView.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 0.7),
            //artistTypeView.topAnchor.constraint(equalTo: artistNameView.bottomAnchor, constant: 10),
            artistTypeView.bottomAnchor.constraint(equalTo: playButton.topAnchor, constant: -10),
            artistTypeView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            artistTypeView.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 0.6),
            //playButton.topAnchor.constraint(equalTo: artistTypeView.bottomAnchor, constant: 10),
            playButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -10),
            playButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor)
        ])
    }
    
    func setDetails(artistName: String, artistType: String, artistPhoto: UIImage)
    {
        artistNameView.text = artistName
        artistTypeView.text = artistType
        artistPhotoView.image = artistPhoto
    }
    
    func changeAlphaOfSubviews(newAlphaValue: CGFloat)
    {
        artistNameView.alpha = newAlphaValue
        artistPhotoView.alpha = newAlphaValue
        artistTypeView.alpha = newAlphaValue
        backgroundView.alpha = newAlphaValue
        playButton.alpha = newAlphaValue
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        containerViewHeight.constant = scrollView.contentInset.top
        let offsetY = -(scrollView.contentOffset.y + scrollView.contentInset.top)
        containerView.clipsToBounds = offsetY <= 0
        backgroundViewBottom.constant = offsetY >= 0 ? 0 : -offsetY / 2
        backgroundViewHeight.constant = max(offsetY, scrollView.contentInset.top)
    }
}
