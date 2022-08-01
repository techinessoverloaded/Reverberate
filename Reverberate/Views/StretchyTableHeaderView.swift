//
//  StretchyTableHeaderView.swift
//  Reverberate
//
//  Created by arun-13930 on 29/07/22.
//

import Foundation
import UIKit

class StretchyTableHeaderView: UIView
{
    var imageViewHeight = NSLayoutConstraint()
    var imageViewBottom = NSLayoutConstraint()
    var containerView: UIView!
    var imageView: UIImageView!
    var overlayView: UIView!
    var containerViewHeight = NSLayoutConstraint()
    var titleView: UILabel!
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        createViews()
        setViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    func createViews()
    {
        // Container View
        containerView = UIView()
        self.addSubview(containerView)
        
        // ImageView for background
        imageView = UIImageView(useAutoLayout: true)
        imageView.clipsToBounds = true
        imageView.backgroundColor = .yellow
        imageView.contentMode = .scaleAspectFill
        
        overlayView = UIView()
        overlayView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        overlayView.backgroundColor = .black
        overlayView.alpha = 0.3
        overlayView.clipsToBounds = true
        
        titleView = UILabel(useAutoLayout: true)
        titleView.textColor = .white
        titleView.font = .systemFont(ofSize: 30, weight: .bold)
        titleView.numberOfLines = 2
        containerView.addSubview(imageView)
        imageView.addSubview(overlayView)
        containerView.insertSubview(titleView, aboveSubview: imageView)
    }
    
    func setViewConstraints()
    {
        // UIView Constraints
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            self.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            self.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        ])
        
        // Container View Constraints
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.widthAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        containerViewHeight = containerView.heightAnchor.constraint(equalTo: self.heightAnchor)
        containerViewHeight.isActive = true
        
        // ImageView Constraints
        imageViewBottom = imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        imageViewBottom.isActive = true
        imageViewHeight = imageView.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        imageViewHeight.isActive = true
        
        NSLayoutConstraint.activate([
            titleView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -10),
            titleView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 20)
        ])
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        containerViewHeight.constant = scrollView.contentInset.top
        let offsetY = -(scrollView.contentOffset.y + scrollView.contentInset.top)
        containerView.clipsToBounds = offsetY <= 0
        imageViewBottom.constant = offsetY >= 0 ? 0 : -offsetY / 2
        imageViewHeight.constant = max(offsetY, scrollView.contentInset.top)
    }
}
