//
//  SignupTableViewCell.swift
//  Reverberate
//
//  Created by arun-13930 on 06/07/22.
//

import UIKit

class SignupTableViewCell: UITableViewCell
{
    static let identifier = "SignupTableViewCell"
    
    private var subView : UIView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder: NSCoder)
    {
        fatalError("Not initialized")
    }
    
    func addSubViewToContentView(_ subView: UIView)
    {
        contentView.addSubview(subView)
        self.subView = subView
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        subView.frame = contentView.bounds
        backgroundColor = .clear
    }
}
