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
        backgroundView.addSubview(artistPhotoView)
        backgroundView.addSubview(artistNameView)
        backgroundView.addSubview(artistTypeView)
        
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            self.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            self.heightAnchor.constraint(equalTo: containerView.heightAnchor),
            containerViewHeight,
            containerView.widthAnchor.constraint(equalTo: backgroundView.widthAnchor),
            backgroundViewHeight,
            backgroundViewBottom,
            artistPhotoView.widthAnchor.constraint(equalToConstant: 140),
            artistPhotoView.heightAnchor.constraint(equalTo: artistPhotoView.widthAnchor),
            artistPhotoView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            artistPhotoView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor, constant: -20),
            artistNameView.topAnchor.constraint(equalTo: artistPhotoView.bottomAnchor, constant: 20),
            artistNameView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            artistNameView.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 0.7),
            artistTypeView.topAnchor.constraint(equalTo: artistNameView.bottomAnchor, constant: 10),
            artistTypeView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            artistTypeView.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 0.6),
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
