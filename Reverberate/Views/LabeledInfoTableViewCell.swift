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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        backgroundColor = .systemFill
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    func configureCell(title: String, infoView: UIView?, arrangeInfoViewToRightEnd: Bool = false, spreadInfoViewFromLeftEnd: Bool = false, widthMultiplier: CGFloat = 0.6, useBrightLabelColor: Bool = false)
    {
        titleLabel.text = title
        titleLabel.textColor = useBrightLabelColor ? .label : .systemGray
        
        guard let infoView = infoView else {
            return
        }
        var variableConstraints: [NSLayoutConstraint]!
        
        variableConstraints = arrangeInfoViewToRightEnd ?
        [infoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)]
        : [infoView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 20)]
        if spreadInfoViewFromLeftEnd
        {
            variableConstraints.append(infoView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: widthMultiplier))
        }
        variableConstraints.append(infoView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor))
        contentView.addSubview(infoView)
        NSLayoutConstraint.activate(variableConstraints)
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
