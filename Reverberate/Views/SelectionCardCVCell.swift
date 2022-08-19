//
//  SelectionCardCVCell.swift
//  Reverberate
//
//  Created by arun-13930 on 07/07/22.
//

import UIKit

class SelectionCardCVCell: UICollectionViewCell
{
    static let identifier = "SelectionCardCVCell"
    
    private let titleLabel: UILabel = {
        let tLabel = UILabel(useAutoLayout: true)
        tLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        tLabel.textAlignment = .left
        tLabel.textColor = .white
        return tLabel
    }()
    
    private let centerTextLabel: UILabel = {
        let ctLabel = UILabel(useAutoLayout: true)
        ctLabel.font = .systemFont(ofSize: 24, weight: .semibold)
        ctLabel.textAlignment = .center
        ctLabel.textColor = .white
        return ctLabel
    }()
    
    private let checkView: UIImageView = {
        let cView = UIImageView(useAutoLayout: true)
        let imageConfig = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 26))
        cView.image = UIImage(systemName: "checkmark.circle.fill", withConfiguration: imageConfig)?.withRenderingMode(.alwaysTemplate)
        cView.tintColor = .systemGreen
        //cView.backgroundColor = .white
        cView.alpha = 0
        return cView
    }()
    
//    private let overlayView: UIView = {
//        let oView = UIView(useAutoLayout: true)
//        oView.backgroundColor = .systemGreen
//        oView.alpha = 0
//        return oView
//    }()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        clipsToBounds = false
        contentView.addSubview(titleLabel)
        contentView.addSubview(centerTextLabel)
        contentView.insertSubview(checkView, aboveSubview: contentView)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            centerTextLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            centerTextLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -18),
            checkView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 18)
        ])
    }
    
    func configureCell(title: String?, centerText: String?, backgroundColor: UIColor?) -> Self
    {
        titleLabel.text = title
        centerTextLabel.text = centerText
        self.backgroundColor = backgroundColor
        return self
    }
    
    override var isSelected: Bool
    {
        didSet
        {
            if self.isSelected
            {
                UIView.transition(with: self, duration: 0.2, options: [.transitionCrossDissolve], animations: { [unowned self] in
                    self.layer.borderWidth = 4
                }, completion: nil)
                
                UIView.transition(with: checkView, duration: 0.2, options: [.transitionCrossDissolve], animations: { [unowned self] in
                    self.checkView.alpha = 1
                }, completion: nil)
            }
            else
            {
                UIView.transition(with: self, duration: 0.2, options: [.transitionCrossDissolve], animations: { [unowned self] in
                    self.layer.borderWidth = 0
                }, completion: nil)
                
                UIView.transition(with: checkView, duration: 0.2, options: [.transitionCrossDissolve], animations: { [unowned self] in
                    self.checkView.alpha = 0
                }, completion: nil)
            }
        }
    }
    
    required init(coder: NSCoder)
    {
        fatalError("Not initialized")
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        layer.cornerRadius = 10
        checkView.layer.cornerRadius = checkView.bounds.width / 2
        layer.shadowPath = UIBezierPath(rect: contentView.bounds).cgPath
        layer.shadowColor = UIColor.label.cgColor
        layer.borderColor = UIColor.systemGreen.cgColor
    }
}
