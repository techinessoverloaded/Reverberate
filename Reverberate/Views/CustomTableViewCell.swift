//
//  SignupTableViewCell.swift
//  Reverberate
//
//  Created by arun-13930 on 06/07/22.
//

import UIKit

class CustomTableViewCell: UITableViewCell
{
    static let identifier = "CustomTableViewCell"
    
    private var subView : UIView!
    
    private var useAutoLayout: Bool = false
    
    private var useClearBackground: Bool = true
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder: NSCoder)
    {
        fatalError("Not initialized")
    }
    
    func addSubViewToContentView(_ subView: UIView, useAutoLayout: Bool = false, useClearBackground: Bool = true)
    {
        contentView.addSubview(subView)
        self.subView = subView
        self.useAutoLayout = useAutoLayout
        self.useClearBackground = useClearBackground
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        if !useAutoLayout
        {
            subView.frame = contentView.bounds
        }
        else
        {
            var constraints: [NSLayoutConstraint] = [
                subView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                subView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ]
            if subView is UIImageView
            {
                constraints.append(subView.heightAnchor.constraint(equalTo: contentView.heightAnchor))
                constraints.append(subView.widthAnchor.constraint(equalTo: subView.heightAnchor))
            }
            NSLayoutConstraint.activate(constraints)
        }
        backgroundColor = useClearBackground ? .clear : backgroundColor
    }
}
