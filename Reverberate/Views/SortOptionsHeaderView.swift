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
    
    lazy var viewModeButton: UIButton = {
        let vmButton = UIButton(type: .custom)
        vmButton.setImage(UIImage(systemName: "square.grid.2x2")!, for: .normal)
        vmButton.tintColor = .secondaryLabel
        vmButton.enableAutoLayout()
        return vmButton
    }()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(orderingButton)
        addSubview(viewModeButton)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            orderingButton.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 10),
            orderingButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            viewModeButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            viewModeButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init(coder: NSCoder)
    {
        fatalError("Not initialized")
    }
}
