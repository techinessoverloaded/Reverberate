//
//  SectionHeaderCV.swift
//  Reverberate
//
//  Created by arun-13930 on 07/09/22.
//

import UIKit

class SectionHeaderCV: UICollectionReusableView
{
    static let identifier = "SectionHeaderCV"
    
    private lazy var titleLabel: UILabel = {
        let tLabel = UILabel(useAutoLayout: true)
        tLabel.font = .preferredFont(forTextStyle: .body, weight: .semibold)
        tLabel.textAlignment = .left
        tLabel.textColor = .label
        return tLabel
    }()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    required init(coder: NSCoder)
    {
        fatalError("Not initialized")
    }
    
    func configure(title: String)
    {
        titleLabel.text = title
    }
}
