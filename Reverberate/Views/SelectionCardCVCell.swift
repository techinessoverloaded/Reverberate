//
//  SelectionCardCVCell.swift
//  Reverberate
//
//  Created by arun-13930 on 07/07/22.
//

import UIKit

class SelectionCardCVCell: UICollectionViewCell
{
    static let identifier = "SelectionCardCVCell"
    
    private let titleLabel: UILabel = {
        let tLabel = UILabel(useAutoLayout: true)
        tLabel.font = .systemFont(ofSize: 20, weight: .bold)
        tLabel.textAlignment = .left
        tLabel.textColor = .white
        return tLabel
    }()
    
    private let centerTextLabel: UILabel = {
        let ctLabel = UILabel(useAutoLayout: true)
        ctLabel.font = .systemFont(ofSize: 26, weight: .bold)
        ctLabel.textAlignment = .center
        ctLabel.textColor = .white
        return ctLabel
    }()
    
    private let imageView: UIImageView = {
        let iView = UIImageView(useAutoLayout: true)
        return iView
    }()
    
    private let overlayView: UIView = {
        let oView = UIView(useAutoLayout: true)
        oView.backgroundColor = .systemGreen
        oView.alpha = 0
        return oView
    }()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.insertSubview(titleLabel, aboveSubview: imageView)
        contentView.insertSubview(centerTextLabel, aboveSubview: imageView)
        selectedBackgroundView = overlayView
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            centerTextLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            centerTextLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    func configureCell(title: String?, centerText: String?, backgroundColor: UIColor?) -> Self
    {
        titleLabel.text = title
        centerTextLabel.text = centerText
        self.backgroundColor = backgroundColor
        return self
    }
    
    func setSelectionOverlayView(isCellSelected: Bool)
    {
        if isCellSelected
        {
            overlayView.alpha = 0.5
            layer.borderWidth = 4
        }
        else
        {
            overlayView.alpha = 0
            layer.borderWidth = 0
        }
    }
    
    required init(coder: NSCoder)
    {
        fatalError("Not initialized")
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        layer.cornerRadius = 10
        overlayView.layer.cornerRadius = 10
        layer.shadowPath = UIBezierPath(rect: contentView.bounds).cgPath
        layer.shadowColor = UIColor.label.cgColor
        layer.borderColor = UIColor.systemGreen.cgColor
    }
}
