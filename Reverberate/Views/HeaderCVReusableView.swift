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
        tLabel.font = .preferredFont(forTextStyle: .title2, weight: .semibold)
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
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            seeAllButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            seeAllButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
        clipsToBounds = true
    }
    
    required init(coder: NSCoder)
    {
        fatalError("Not initialized")
    }
    
    func configure(title: String, shouldShowSeeAllButton: Bool = true, tagForSeeAllButton: Int? = nil, headerFontColorOpacity: CGFloat = 1)
    {
        titleLabel.text = title
        if headerFontColorOpacity != 1
        {
            titleLabel.textColor = .label.withAlphaComponent(headerFontColorOpacity)
        }
        seeAllButton.isHidden = !shouldShowSeeAllButton
        seeAllButton.tag = tagForSeeAllButton ?? -1
    }
    
    func addTargetToSeeAllButton(target: Any, action: Selector)
    {
        seeAllButton.addTarget(target, action: action, for: .touchUpInside)
    }
}
