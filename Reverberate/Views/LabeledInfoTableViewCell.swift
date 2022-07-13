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
    
    private lazy var errorLabel: UILabel = {
        let eLabel = UILabel(useAutoLayout: true)
        eLabel.textColor = .systemRed
        eLabel.font = .preferredFont(forTextStyle: .footnote)
        eLabel.text = "Required"
        eLabel.textAlignment = .right
        eLabel.isHidden = true
        return eLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        backgroundColor = .systemFill
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3)
        ])
    }
    
    func configureCell(title: String, infoView: UIView?, arrangeInfoViewToRightEnd: Bool = false, spreadInfoViewFromLeftEnd: Bool = false, widthMultiplier: CGFloat = 0.6, useBrightLabelColor: Bool = false, addErrorLabel: Bool = false)
    {
        titleLabel.text = title
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
        if addErrorLabel
        {
            variableConstraints.append(errorLabel.topAnchor.constraint(equalTo: infoView.bottomAnchor, constant: 10))
            variableConstraints.append(errorLabel.trailingAnchor.constraint(equalTo: infoView.trailingAnchor))
            contentView.addSubview(errorLabel)
        }
        contentView.addSubview(infoView)
        NSLayoutConstraint.activate(variableConstraints)
        contentView.preservesSuperviewLayoutMargins = true
    }
    
    func setError(isErrorPresent: Bool, message: String? = nil)
    {
        if isErrorPresent
        {
            errorLabel.text = message
            errorLabel.isHidden = false
        }
        else
        {
            errorLabel.isHidden = true
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
