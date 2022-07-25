//
//  ArtistCVCell.swift
//  Reverberate
//
//  Created by arun-13930 on 25/07/22.
//

import UIKit

class ArtistCVCell: UICollectionViewCell
{
    static let identifier = "ArtistCVCell"
    
    private lazy var defaultArtistPicture: UIImage = {
        let config = UIImage.SymbolConfiguration(paletteColors: [UIColor.systemGray])
        let dAPicture = UIImage(systemName: "person.crop.circle.fill", withConfiguration: config)!
        return dAPicture
    }()
    
    private lazy var artistPictureView: UIImageView = {
        let apView = UIImageView(useAutoLayout: true)
        apView.contentMode = .scaleAspectFill
        apView.clipsToBounds = true
        apView.layer.cornerCurve = .circular
        apView.layer.cornerRadius = bounds.size.width * 0.5
        apView.layer.borderColor = UIColor(named: GlobalConstants.techinessColor)!.cgColor
        apView.layer.borderWidth = 4
        return apView
    }()
    
    private lazy var artistNameView: UILabel = {
        let stView = UILabel(useAutoLayout: true)
        stView.textColor = .label.withAlphaComponent(0.8)
        stView.font = .preferredFont(forTextStyle: .title3, weight: .semibold)
        stView.textAlignment = .center
        stView.lineBreakMode = .byTruncatingTail
        stView.numberOfLines = 3
        return stView
    }()
    
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        backgroundColor = .clear
        contentView.addSubview(artistPictureView)
        contentView.addSubview(artistNameView)
        NSLayoutConstraint.activate([
            artistPictureView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            artistPictureView.heightAnchor.constraint(equalTo: artistPictureView.widthAnchor),
            artistPictureView.topAnchor.constraint(equalTo: contentView.topAnchor),
            artistNameView.topAnchor.constraint(equalTo: artistPictureView.bottomAnchor, constant: 10),
            artistNameView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            artistNameView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
        ])
    }
    
    required init(coder: NSCoder)
    {
        fatalError("Not Initialized")
    }
    
    func configureCell(artistPicture: UIImage? = nil, artistName: String)
    {
        if let artistPicture = artistPicture
        {
            artistPictureView.image = artistPicture
        }
        else
        {
            artistPictureView.image = defaultArtistPicture
        }
        artistNameView.text = artistName
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        artistPictureView.layer.cornerRadius = bounds.size.width * 0.5
    }
}
