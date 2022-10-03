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
        tLabel.font = .preferredFont(forTextStyle: .body)
        return tLabel
    }()
    
    private var originalTitle: String!
    
    var hasError: Bool
    {
        get
        {
            layer.borderWidth != 0
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        layer.borderColor = UIColor.systemRed.cgColor
        layer.borderWidth = 0
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 17),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.32)
        ])
    }
    
    func configureCell(title: String, infoView: UIView?, arrangeInfoViewToRightEnd: Bool = false, spreadInfoViewFromLeftEnd: Bool = false, widthMultiplier: CGFloat = 0.58, useBrightLabelColor: Bool = false)
    {
        titleLabel.text = title
        originalTitle = title
        titleLabel.textColor = useBrightLabelColor ? .label : .systemGray
        guard let infoView = infoView else {
            return
        }
        var variableConstraints: [NSLayoutConstraint]!
        
        variableConstraints = arrangeInfoViewToRightEnd ?
        [infoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)]
        : [infoView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 14)]
        if spreadInfoViewFromLeftEnd
        {
            variableConstraints.append(infoView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: widthMultiplier))
        }
        variableConstraints.append(infoView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor))
        contentView.addSubview(infoView)
        NSLayoutConstraint.activate(variableConstraints)
        contentView.preservesSuperviewLayoutMargins = true
    }
    
    func setError(isErrorPresent: Bool, message: String? = nil)
    {
        if isErrorPresent
        {
            layer.borderWidth = 2
            titleLabel.textColor = .systemRed
            titleLabel.text = message
            titleLabel.font = .preferredFont(forTextStyle: .subheadline)
        }
        else
        {
            layer.borderWidth = 0
            titleLabel.textColor = .systemGray
            titleLabel.text = originalTitle
            titleLabel.font = .preferredFont(forTextStyle: .body)
        }
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
