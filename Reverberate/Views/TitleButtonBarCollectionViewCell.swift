//
//  TitleButtonBarCollectionViewCell.swift
//  Reverberate
//
//  Created by arun-13930 on 08/07/22.
//

import UIKit

class TitleButtonBarCollectionViewCell: UICollectionViewCell
{
    static let identifier = "TitleButtonBarCollectionViewCell"
    
    private let titleLabel: UILabel = {
        let tLabel = UILabel(useAutoLayout: true)
        tLabel.textColor = .label
        tLabel.font = .systemFont(ofSize: 22, weight: .bold)
        return tLabel
    }()
    
    private let leftButton: UIButton = {
        var lButtonConfig = UIButton.Configuration.borderless()
        lButtonConfig.baseForegroundColor = .init(named: GlobalConstants.techinessColor)
        let lButton = UIButton(configuration: lButtonConfig)
        lButton.isEnabled = false
        lButton.enableAutoLayout()
        return lButton
    }()
    
    private let rightButton: UIButton = {
        var rButtonConfig = UIButton.Configuration.borderless()
        rButtonConfig.baseForegroundColor = .init(named: GlobalConstants.techinessColor)
        let rButton = UIButton(configuration: rButtonConfig)
        rButton.isEnabled = false
        rButton.enableAutoLayout()
        return rButton
    }()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        contentView.addSubview(leftButton)
        contentView.addSubview(rightButton)
        NSLayoutConstraint.activate([
            leftButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            leftButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            rightButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            rightButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            titleLabel.topAnchor.constraint(equalTo: leftButton.bottomAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
        ])
    }
    
    required init(coder: NSCoder)
    {
        fatalError("Not initialized")
    }
    
    func configureCell(title: String, leftButtonTitle: String?, buttonTarget: Any?, leftButtonAction: Selector?,  rightButtonTitle: String?, rightButtonAction: Selector?) -> (leftButtonRef: UIButton?, rightButtonRef: UIButton?)
    {
        titleLabel.text = title
        leftButton.setTitle(leftButtonTitle, for: .normal)
        rightButton.setTitle(rightButtonTitle, for: .normal)
        if rightButtonAction != nil
        {
            rightButton.addTarget(buttonTarget, action: rightButtonAction!, for: .touchUpInside)
        }
        if leftButtonAction != nil
        {
            leftButton.addTarget(buttonTarget, action: leftButtonAction!, for: .touchUpInside)
        }
        return (leftButtonAction != nil ? leftButton : nil, rightButtonAction != nil ? rightButton : nil)
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
    }
}
