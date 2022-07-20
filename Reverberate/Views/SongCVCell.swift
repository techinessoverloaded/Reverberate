//
//  SongCVCell.swift
//  Reverberate
//
//  Created by arun-13930 on 20/07/22.
//

import UIKit

class SongCVCell: UICollectionViewCell
{
    static let identifier = "SongCVCell"
    
    private lazy var songPosterView: UIImageView = {
        let spView = UIImageView(useAutoLayout: true)
        spView.contentMode = .scaleAspectFill
        spView.clipsToBounds = true
        return spView
    }()
    
    private lazy var songTitleView: UILabel = {
        let stView = UILabel(useAutoLayout: true)
        stView.textColor = .label
        stView.font = .systemFont(ofSize: 17, weight: .heavy)
        stView.textAlignment = .left
        stView.lineBreakMode = .byTruncatingTail
        stView.numberOfLines = 2
        return stView
    }()
    
    private lazy var artistsView: UILabel = {
        let aView = UILabel(useAutoLayout: true)
        aView.textColor = .label
        aView.font = .systemFont(ofSize: 14, weight: .semibold)
        aView.textAlignment = .left
        aView.lineBreakMode = .byTruncatingTail
        return aView
    }()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        backgroundColor = .clear
        contentView.addSubview(songPosterView)
        contentView.addSubview(songTitleView)
        contentView.addSubview(artistsView)
        NSLayoutConstraint.activate([
            songPosterView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            songPosterView.heightAnchor.constraint(equalTo: songPosterView.widthAnchor),
            songPosterView.topAnchor.constraint(equalTo: contentView.topAnchor),
            songTitleView.topAnchor.constraint(equalTo: songPosterView.bottomAnchor, constant: 5),
            songTitleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            songTitleView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            artistsView.topAnchor.constraint(equalTo: songTitleView.bottomAnchor, constant: 5),
            artistsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            artistsView.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
    }
    
    required init(coder: NSCoder)
    {
        fatalError("Not Initialized")
    }
    
    func configureCell(songPoster: UIImage = UIImage(named: "glassmorphic_bg")!, songTitle: String, artistNames: String)
    {
        songPosterView.image = songPoster
        songTitleView.text = songTitle
        artistsView.text = artistNames
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        songPosterView.layer.cornerRadius = 10
        songPosterView.layer.cornerCurve = .continuous
        contentView.layer.cornerRadius = 10
        contentView.layer.cornerCurve = .continuous
        contentView.layer.shadowPath = UIBezierPath(rect: contentView.bounds).cgPath
    }
    
}
