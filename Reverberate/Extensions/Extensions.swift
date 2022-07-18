//
//  Extensions.swift
//  Reverberate
//
//  Created by arun-13930 on 05/07/22.
//

import UIKit
import Photos
import PhotosUI

extension UIView
{
    convenience init(useAutoLayout: Bool)
    {
        self.init()
        self.translatesAutoresizingMaskIntoConstraints = !useAutoLayout
    }
    
    func enableAutoLayout()
    {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addTopCornerRadius(radius: CGFloat = 10)
    {
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        self.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        self.layer.cornerCurve = .circular
    }
    
    func addBottomCornerRadius(radius: CGFloat = 10)
    {
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        self.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        self.layer.cornerCurve = .circular
    }
    
}

extension UITextField
{
    func addReturnButtonToKeyboard(target: Any, action: Selector, title: String = "done")
    {
        let returnToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        returnToolbar.barStyle = UIBarStyle.default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let returnBtn: UIBarButtonItem = UIBarButtonItem(title: title, style: UIBarButtonItem.Style.done, target: target, action: action)
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(returnBtn)
        returnToolbar.items = items
        returnToolbar.sizeToFit()
        self.inputAccessoryView = returnToolbar
    }
    
    func removeReturnButtonFromKeyboard()
    {
        self.inputAccessoryView = nil
    }
    
    var isInvalid: Bool
    {
        get
        {
            self.layer.borderColor == UIColor.systemRed.cgColor && self.layer.borderWidth == 2
        }
        set
        {
            if newValue
            {
                self.layer.borderWidth = 2
                self.layer.borderColor = UIColor.systemRed.cgColor
            }
            else
            {
                self.layer.borderWidth = 0
                self.layer.borderColor = UIColor(named: GlobalConstants.techinessColor)!.cgColor
            }
        }
    }
}

extension NSRegularExpression
{
    convenience init(_ pattern: String)
    {
        do
        {
            try self.init(pattern: pattern)
        }
        catch
        {
            preconditionFailure("Illegal regular expression: \(pattern).")
        }
    }
    
    func matches(_ string: String) -> Bool
    {
        let range = NSRange(location: 0, length: string.utf16.count)
        return firstMatch(in: string.trimmingCharacters(in: .whitespaces), options: [], range: range) != nil
    }
}

extension UIViewController
{
    var isInPortraitMode: Bool
    {
        get
        {
            return UIDevice.current.orientation == .portrait || UIDevice.current.orientation == .portraitUpsideDown
        }
    }
}

extension UIImageView
{
    func addButtonToImageView(title: String)
    {
        let titleLabel = UILabel(useAutoLayout: true)
        titleLabel.textColor = .systemBlue
        titleLabel.backgroundColor = .black
        titleLabel.text = title
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 14, weight: .bold)
        titleLabel.clipsToBounds = true
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalTo: widthAnchor),
            titleLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3)
        ])
    }
}

extension String
{
    mutating func trim()
    {
        self = self.trimmingCharacters(in: .whitespaces)
    }
    
    func trimmedCopy() -> Self
    {
        return self.trimmingCharacters(in: .whitespaces)
    }
}

extension UIViewController
{
    var isUserLoggedIn: Bool
    {
        get
        {
            return UserDefaults.standard.string(forKey: GlobalConstants.currentUserId) != nil
        }
    }
}

extension URL
{
    static func localURLForXCAsset(name: String) -> URL?
    {
        let fileManager = FileManager.default
        guard let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {return nil}
        let url = cacheDirectory.appendingPathComponent("songs/\(name).mp3")
        let path = url.path
        if !fileManager.fileExists(atPath: path)
        {
            guard let data = try? Data(contentsOf: url) else
            {
                return nil
            }
            fileManager.createFile(atPath: path, contents: data, attributes: nil)
        }
        return url
    }
}