//
//  StretchyTableHeaderView.swift
//  Reverberate
//
//  Created by arun-13930 on 29/07/22.
//

import Foundation
import UIKit

class StretchyHeaderView: UIView
{
    private lazy var backgroundViewHeight: NSLayoutConstraint = backgroundView.heightAnchor.constraint(equalTo: containerView.heightAnchor)
    
    private lazy var backgroundViewBottom: NSLayoutConstraint = backgroundView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
    
    private lazy var containerViewHeight: NSLayoutConstraint = containerView.heightAnchor.constraint(equalTo: self.heightAnchor)
    
    private lazy var containerView: UIView = UIView(useAutoLayout: true)
    
    private lazy var photoView: UIImageView = {
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
        return bView
    }()
    
    private lazy var titleView: UILabel = {
        let anView = UILabel(useAutoLayout: true)
        anView.textColor = .white
        anView.font = .systemFont(ofSize: 28, weight: .bold)
        anView.textAlignment = .center
        anView.numberOfLines = 2
        return anView
    }()
    
    private lazy var subtitleView: UILabel = {
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
        backgroundView.addSubview(photoView)
        backgroundView.addSubview(titleView)
        backgroundView.addSubview(subtitleView)
        
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            self.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            self.heightAnchor.constraint(equalTo: containerView.heightAnchor),
            containerViewHeight,
            containerView.widthAnchor.constraint(equalTo: backgroundView.widthAnchor),
            backgroundViewHeight,
            backgroundViewBottom,
            photoView.widthAnchor.constraint(equalToConstant: 140),
            photoView.heightAnchor.constraint(equalTo: photoView.widthAnchor),
            photoView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            photoView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor, constant: -20),
            titleView.topAnchor.constraint(equalTo: photoView.bottomAnchor, constant: 20),
            titleView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            titleView.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 0.7),
            subtitleView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 10),
            subtitleView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            subtitleView.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 0.6),
        ])
    }
    
    func setDetails(title: String, subtitle: String? = nil, photo: UIImage? = nil, backgroundImage: UIImage? = nil)
    {
        titleView.text = title
        subtitleView.text = subtitle
        photoView.image = photo
        backgroundView.image = backgroundImage == nil ? UIImage(named: "dark_gradient_bg")! : backgroundImage
    }
    
    func changeAlphaOfSubviews(newAlphaValue: CGFloat)
    {
        titleView.alpha = newAlphaValue
        photoView.alpha = newAlphaValue
        subtitleView.alpha = newAlphaValue
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
