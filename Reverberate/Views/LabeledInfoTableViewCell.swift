//
//  LabeledInfoTableViewCell.swift
//  Reverberate
//
//  Created by arun-13930 on 11/07/22.
//

import UIKit

class LabeledInfoTableViewCell: UITableViewCell
{
    static let identifier = "LabeledInfoTableViewCell"
    
    private let titleLabel: UILabel = {
        let tLabel = UILabel(useAutoLayout: true)
        tLabel.font = .preferredFont(forTextStyle: .subheadline)
        return tLabel
    }()
    
    private let infoView: UIView = {
        let iView = UIView(useAutoLayout: true)
        return iView
    }()
    
    private let rightArrowView: UIImageView = {
        let raView = UIImageView(useAutoLayout: true)
        raView.tintColor = .opaqueSeparator
        return raView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(infoView)
        contentView.addSubview(rightArrowView)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            infoView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 20),
            infoView.trailingAnchor.constraint(equalTo: rightArrowView.leadingAnchor, constant: -10),
            infoView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            rightArrowView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            rightArrowView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configureCell(title: String, rightView: UIView?, shouldShowArrow: Bool = false, useBrightLabelColor: Bool = false)
    {
        titleLabel.text = title
        titleLabel.textColor = useBrightLabelColor ? .label : .systemGray
        rightArrowView.image = UIImage(systemName: "chevron.right")
        rightArrowView.isHidden = !shouldShowArrow
        guard let rightView = rightView else {
            return
        }
        infoView.addSubview(rightView)
        NSLayoutConstraint.activate([
            rightView.centerYAnchor.constraint(equalTo: infoView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder)
    {
        return nil
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
    }
}
