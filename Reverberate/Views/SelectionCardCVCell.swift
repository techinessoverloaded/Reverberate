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
        tLabel.font = .systemFont(ofSize: 17, weight: .bold)
        tLabel.textAlignment = .left
        tLabel.textColor = .label
        return tLabel
    }()
    
    private let centerTextLabel: UILabel = {
        let ctLabel = UILabel(useAutoLayout: true)
        ctLabel.font = .systemFont(ofSize: 25, weight: .bold)
        ctLabel.textAlignment = .center
        ctLabel.textColor = .label
        return ctLabel
    }()
    
    private let imageView: UIImageView = {
        let iView = UIImageView(useAutoLayout: true)
        return iView
    }()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.insertSubview(titleLabel, aboveSubview: imageView)
        contentView.insertSubview(centerTextLabel, aboveSubview: imageView)
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            centerTextLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            centerTextLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configureCell(title: String?, centerText: String?, backgroundColor: UIColor?) -> Self
    {
        titleLabel.text = title
        centerTextLabel.text = centerText
        self.backgroundColor = backgroundColor
        return self
    }
    
    required init(coder: NSCoder)
    {
        fatalError("Not initialized")
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        layer.cornerRadius = 10
        layer.shadowPath = UIBezierPath(rect: contentView.frame).cgPath
        layer.borderColor = UIColor.green.cgColor
    }
}
