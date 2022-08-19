//
//  SongCVCell.swift
//  Reverberate
//
//  Created by arun-13930 on 20/07/22.
//

import UIKit

class PosterDetailCVCell: UICollectionViewCell
{
    static let identifier = "PosterDetailCVCell"
    
    private lazy var posterView: UIImageView = {
        let pView = UIImageView(useAutoLayout: true)
        pView.contentMode = .scaleAspectFill
        pView.clipsToBounds = true
        pView.isUserInteractionEnabled = true
        return pView
    }()
    
    private lazy var titleView: UILabel = {
        let tView = UILabel(useAutoLayout: true)
        tView.textColor = .label
        tView.font = .preferredFont(forTextStyle: .body, weight: .semibold)
        tView.textAlignment = .left
        tView.lineBreakMode = .byTruncatingTail
        tView.numberOfLines = 1
        tView.isUserInteractionEnabled = true
        return tView
    }()
    
    private lazy var subtitleView: UILabel = {
        let stView = UILabel(useAutoLayout: true)
        stView.textColor = .label
        stView.font = .preferredFont(forTextStyle: .footnote, weight: .regular)
        stView.textAlignment = .left
        stView.lineBreakMode = .byTruncatingTail
        stView.isUserInteractionEnabled = true
        return stView
    }()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        backgroundColor = .clear
        contentView.addSubview(posterView)
        contentView.addSubview(titleView)
        contentView.addSubview(subtitleView)
        NSLayoutConstraint.activate([
            posterView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            posterView.heightAnchor.constraint(equalTo: posterView.widthAnchor),
            posterView.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleView.topAnchor.constraint(equalTo: posterView.bottomAnchor, constant: 5),
            titleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            subtitleView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 5),
            subtitleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            subtitleView.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
    }
    
    required init(coder: NSCoder)
    {
        fatalError("Not Initialized")
    }
    
    func configureCell(poster: UIImage = UIImage(named: "glassmorphic_bg")!, title: String, subtitle: String?)
    {
        posterView.image = poster
        titleView.text = title
        subtitleView.text = subtitle
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        posterView.layer.cornerRadius = 10
        posterView.layer.cornerCurve = .continuous
        contentView.layer.cornerRadius = 10
        contentView.layer.cornerCurve = .continuous
        contentView.layer.shadowPath = UIBezierPath(rect: contentView.bounds).cgPath
    }
}
