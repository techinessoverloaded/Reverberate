//
//  TitleCardCVCell.swift
//  Reverberate
//
//  Created by arun-13930 on 19/07/22.
//

import UIKit

class TitleCardCVCell: UICollectionViewCell
{
    static let identifier = "TitleCardCVCell"
    
    private let titleLabel: UILabel = {
        let tLabel = UILabel(useAutoLayout: true)
        tLabel.font = .preferredFont(forTextStyle: .title2, weight: .bold)
        tLabel.textAlignment = .center
        tLabel.textColor = .white
        return tLabel
    }()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init(coder: NSCoder)
    {
        fatalError("Not initialized")
    }
   
    func configureCell(title: String, backgroundColor: UIColor) -> Self
    {
        titleLabel.text = title
        self.backgroundColor = backgroundColor
        return self
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        layer.cornerRadius = 10
        layer.shadowPath = UIBezierPath(rect: contentView.bounds).cgPath
        layer.shadowColor = UIColor.label.cgColor
    }
}
