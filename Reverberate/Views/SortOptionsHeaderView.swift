//
//  SortOptionsHeaderView.swift
//  Reverberate
//
//  Created by arun-13930 on 19/07/22.
//

import UIKit

class SortOptionsHeaderView: UIView
{
    private lazy var titleLabel: UILabel = {
        let tLabel = UILabel(useAutoLayout: true)
        tLabel.font = .preferredFont(forTextStyle: .body)
        tLabel.textColor = .secondaryLabel
        tLabel.textAlignment = .left
        tLabel.text = "SORT BY"
        return tLabel
    }()
    
    lazy var orderingButton: UIButton = {
        let oButton = UIButton(type: .custom)
        oButton.setImage(UIImage(systemName: "arrow.up.arrow.down")!, for: .normal)
        oButton.tintColor = .secondaryLabel
        oButton.enableAutoLayout()
        return oButton
    }()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(orderingButton)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            orderingButton.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 10),
            orderingButton.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    required init(coder: NSCoder)
    {
        fatalError("Not initialized")
    }
}
