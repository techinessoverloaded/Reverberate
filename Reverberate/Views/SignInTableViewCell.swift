//
//  SignInTableViewCell.swift
//  Reverberate
//
//  Created by arun-13930 on 14/07/22.
//

import UIKit

class SignInTableViewCell: UITableViewCell
{
    static let identifier = "SignInTableViewCell"
    
    private let iconView: UIImageView = {
        let iView = UIImageView(useAutoLayout: true)
        iView.image = UIImage(systemName: "person.crop.circle.fill")!
        iView.tintColor = .systemGray
        return iView
    }()
    
    private let titleView: UILabel = {
        let tView = UILabel(useAutoLayout: true)
        tView.font = .preferredFont(forTextStyle: .body)
        tView.textColor = .systemBlue
        return tView
    }()
    
    private let subtitleView: UILabel = {
        let sView = UILabel(useAutoLayout: true)
        sView.font = .systemFont(ofSize: 14)
        sView.textColor = .label
        return sView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(iconView)
        contentView.addSubview(titleView)
        contentView.addSubview(subtitleView)
        NSLayoutConstraint.activate([
            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            iconView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7),
            iconView.widthAnchor.constraint(equalTo: iconView.heightAnchor),
            titleView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -10),
            titleView.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 10),
            titleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            subtitleView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 8),
            subtitleView.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
            subtitleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        
    }
    
    func configureCell(title: String, subtitle: String) -> Self
    {
        titleView.text = title
        subtitleView.text = subtitle
        return self
    }
    
    required init?(coder: NSCoder)
    {
        fatalError()
    }
}
