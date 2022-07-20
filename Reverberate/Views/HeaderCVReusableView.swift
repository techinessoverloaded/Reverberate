//
//  HeaderCVReusableView.swift
//  Reverberate
//
//  Created by arun-13930 on 20/07/22.
//

import UIKit

class HeaderCVReusableView: UICollectionReusableView
{
    static let identifier = "HeaderCVReusableView"
    
    private lazy var titleLabel: UILabel = {
        let tLabel = UILabel(useAutoLayout: true)
        tLabel.font = .systemFont(ofSize: 26, weight: .bold)
        tLabel.textAlignment = .left
        tLabel.textColor = .label
        return tLabel
    }()
    
    lazy var seeAllButton: UIButton = {
        let smButton = UIButton(type: .system)
        smButton.setTitle("See All", for: .normal)
        smButton.enableAutoLayout()
        return smButton
    }()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(seeAllButton)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 12),
            seeAllButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            seeAllButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
    }
    
    required init(coder: NSCoder)
    {
        fatalError("Not initialized")
    }
    
    func configure(title: String, shouldShowSeeAllButton: Bool = true) -> Self
    {
        titleLabel.text = title
        seeAllButton.isHidden = !shouldShowSeeAllButton
        return self
    }
}
