//
//  SignupTableMultiViewCell.swift
//  Reverberate
//
//  Created by arun-13930 on 06/07/22.
//

import UIKit

class SignupTableMultiViewCell: UITableViewCell
{
    static let identifier = "SignupTableMultiViewCell"
    
    var subView1: UIView!
    var subView2: UIView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder: NSCoder)
    {
        fatalError("Not initialized")
    }
    
    func addSubViewsToContentView(subView1: UIView, subView2: UIView)
    {
        contentView.addSubview(subView1)
        contentView.addSubview(subView2)
        self.subView1 = subView1
        self.subView2 = subView2
        NSLayoutConstraint.activate([
            self.subView1.topAnchor.constraint(equalTo: contentView.topAnchor),
            self.subView1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            self.subView1.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            self.subView1.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            self.subView2.topAnchor.constraint(equalTo: self.subView1.bottomAnchor),
            self.subView2.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            self.subView2.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            self.subView2.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        backgroundColor = .clear
    }
}
