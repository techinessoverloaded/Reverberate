//
//  Extensions.swift
//  Reverberate
//
//  Created by arun-13930 on 05/07/22.
//

import UIKit
import Foundation

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
    
    func disableAutoLayout()
    {
        self.translatesAutoresizingMaskIntoConstraints = true
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
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
    
    var isInPortraitMode: Bool
    {
        get
        {
            return UIDevice.current.orientation.isPortrait ? true : (UIDevice.current.orientation == .unknown ? true : false)
        }
    }
    
    var isIpad: Bool
    {
        get
        {
            return UIDevice.current.userInterfaceIdiom == .pad
        }
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
            return UIDevice.current.orientation.isPortrait ? true : (UIDevice.current.orientation == .unknown ? true : false)
        }
    }
    
    var isIpad: Bool
    {
        get
        {
            return UIDevice.current.userInterfaceIdiom == .pad
        }
    }
    
    func address(of pointer: UnsafeRawPointer) -> Int
    {
        return Int(bitPattern: pointer)
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
    
    func getNameWithoutExtension() -> Self?
    {
        guard self.contains(".") else
        {
            return nil
        }
        return String(self[..<self.firstIndex(of: ".")!])
    }
    
    func getExtension() -> Self?
    {
        guard self.contains(".") else
        {
            return nil
        }
        return String(self[self.firstIndex(of: ".")!...])
    }
    
    func getAlphaNumericLowercasedString() -> Self
    {
        return self.components(separatedBy: CharacterSet.alphanumerics.inverted).joined().lowercased()
    }
}

extension NSAttributedString
{
    static func getAttributedString(string1: String, string2: String, separator: String) -> NSMutableAttributedString
    {
        let largeTextAttributes: [NSAttributedString.Key : Any] =
        [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 19, weight: .bold),
            NSAttributedString.Key.foregroundColor : UIColor.label
        ]
        let smallerTextAttributes: [NSAttributedString.Key : Any] =
        [
            NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: .body),
            NSAttributedString.Key.foregroundColor : UIColor.secondaryLabel
        ]
        let mutableAttrString = NSMutableAttributedString(string: "\(string1)\(separator)", attributes: largeTextAttributes)
        mutableAttrString.append(NSMutableAttributedString(string: string2, attributes: smallerTextAttributes))
        return mutableAttrString
    }
    
    static var newLine: NSMutableAttributedString
    {
        get
        {
            NSMutableAttributedString(string: "\n")
        }
    }
}

extension NSMutableAttributedString
{
    func appendWithNewLine(_ attrString: NSAttributedString)
    {
        self.append(attrString)
        self.append(NSAttributedString.newLine)
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

extension UIColor
{
    static func randomDarkColor(withAlpha alpha: CGFloat = 1) -> Self
    {
        let red = CGFloat(UInt.random(in: 11...145)) / 255
        let green = CGFloat(UInt.random(in: 11...145)) / 255
        let blue = CGFloat(UInt.random(in: 11...145)) / 255
        return self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage
    {
        return UIGraphicsImageRenderer(size: size).image
        { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}

extension UIFont
{
    static func preferredFont(forTextStyle style: TextStyle, weight: Weight, italic: Bool = false) -> UIFont
    {
        // Get the style's default pointSize
        let traits = UITraitCollection(preferredContentSizeCategory: .large)
        let desc = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style, compatibleWith: traits)

        // Get the font at the default size and preferred weight
        var font = UIFont.systemFont(ofSize: desc.pointSize, weight: weight)
        if italic == true {
            font = font.with([.traitItalic])
        }

        // Setup the font to be auto-scalable
        let metrics = UIFontMetrics(forTextStyle: style)
        return metrics.scaledFont(for: font)
    }
    
    private func with(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
        guard let descriptor = fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits).union(fontDescriptor.symbolicTraits)) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: 0)
    }
}

extension UILabel
{
    private struct PropertyHolder
    {
        static var timer: Timer?
        static var originalText: String!
    }
    
    convenience init(useAutoLayout: Bool, adjustsFontAccordingToCategory: Bool = true)
    {
        self.init(useAutoLayout: useAutoLayout)
        self.adjustsFontForContentSizeCategory = adjustsFontAccordingToCategory
    }
    
    var isTruncated: Bool
    {
        if self.translatesAutoresizingMaskIntoConstraints == false
        {
            self.layoutIfNeeded()
        }
        
        if let labelText = text
        {
            let labelTextSize = (labelText as NSString).boundingRect(with: CGSize(width: frame.size.width, height: .greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [.font : font!], context: nil).size
            return labelTextSize.height > bounds.size.height
        }
        else if let labelAttributedText = attributedText
        {
            let labelAttributedTextSize = (labelAttributedText as NSAttributedString).boundingRect(with: CGSize(width: frame.size.width, height: .greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil).size
            return labelAttributedTextSize.height > bounds.size.height
        }
        else
        {
            return false
        }
    }
    
    func enableMarqueeIfNeeded()
    {
        if isTruncated
        {
            PropertyHolder.originalText = self.text!
            PropertyHolder.timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { _ in
                DispatchQueue.main.async { [unowned self] in
                    var alternator = 0
                    if alternator.isMultiple(of: 2)
                    {
                        if let text = self.text, !text.isEmpty {
                            let index = text.index(after: text.startIndex)
                            self.text = String(self.text![index...])
                        }
                    }
                    else
                    {
                        if let text = self.text, !text.isEmpty {
                            let index = text.index(before: text.endIndex)
                            self.text = String(self.text![..<index])
                        }
                    }
                    if self.text!.isEmpty
                    {
                        self.text = PropertyHolder.originalText
                    }
                    alternator += 1
                }
            }
        }
    }
    
    func disableMarquee()
    {
        if PropertyHolder.timer != nil
        {
            PropertyHolder.timer!.invalidate()
            self.text = PropertyHolder.originalText
            self.lineBreakMode = .byTruncatingTail
        }
    }
}

extension NSNotification.Name
{
    static let currentSongSetNotification = NSNotification.Name("cUrReNtSoNgSeTnOtIfIcAtIoN")
    static let currentPlaylistSetNotification = NSNotification.Name("cUrReNtPlAyLiStSeTnOtIfIcAtIoN")
    static let playerPausedNotification = NSNotification.Name("pLaYeRpAuSeDnOtIfIcAtIoN")
    static let playerPlayNotification = NSNotification.Name("pLaYeRpLaYnOtIfIcAtIoN")
    static let languageGenreChangeNotification = NSNotification.Name("lAnGuAgEgEnReChAnGeNoTiFiCaTiOn")
    static let showAlbumTapNotification = NSNotification.Name("sHoWaLbUmTaPnOtIfIcAtIoN")
    static let addSongToFavouritesNotification = NSNotification.Name("aDdSoNgToFaVoUrItEsNoTiFiCaTiOn")
    static let removeSongFromFavouritesNotification = NSNotification.Name("ReMoVeSoNgFrOmFaVoUrItEsNoTiFiCaTiOn")
    static let addSongToPlaylistNotification = NSNotification.Name("aDdSoNgToPlAyLiStNoTiFiCaTiOn")
    static let removeSongFromPlaylistNotification = NSNotification.Name("rEmOvEsOnGfRoMpLaYlIsTnOtIfIcAtIoN")
    static let addAlbumToFavouritesNotification = NSNotification.Name("aDdAlBuMtOfAvOuRiTeSnOtIfIcAtIoN")
    static let removeAlbumFromFavouritesNotification = NSNotification.Name("rEmOvEaLbUmFrOmFaVoUrItEsNoTiFiCaTiOn")
    static let addArtistToFavouritesNotification = NSNotification.Name("AdDaRtIsTtOfAvOuRiTeSnOtIfIcAtIoN")
    static let removeArtistFromFavouritesNotification = NSNotification.Name("ReMoVeArTiStFrOmFaVoUrItEsNoTiFiCaTiOn")
    static let userLoggedInNotification = NSNotification.Name("uSeRlOgGeDiNnOtIfIcAtIoN")
    static let userLoggedOutNotification = NSNotification.Name("uSeRlOgGeDoUtNoTiFiCaTiOn")
    static let loginRequestNotification = NSNotification.Name("LoGiNREqUeStNoTiFiCaTiOn")
    static let removePlaylistNotification = NSNotification.Name("removePlaylistNotification")
    static let upcomingSongClickedNotification = NSNotification.Name("upcomingSongClickedNotification")
    static let previousSongClickedNotification = NSNotification.Name("previousSongClickedNotification")
    static let recentlyPlayedListChangedNotification = NSNotification.Name("recentlyPlayedListChangedNotification")
    static let songRemovedFromPlaylistNotification = NSNotification.Name("songRemovedFromPlaylistNotification")
    static let songAddedToPlaylistNotification = NSNotification.Name("songAddedToPlaylistNotification")
}

extension DateFormatter
{
    static func getDateFromString(dateString: String) -> Date?
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter.date(from: dateString)
    }
}

extension Date
{
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int
    {
        return calendar.component(component, from: self)
    }
    
    func getFormattedString() -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM y"
        return formatter.string(from: self)
    }
}

extension Calendar
{
    static var currentYear: Int
    {
        get
        {
            return Calendar(identifier: .gregorian).component(.year, from: .now)
        }
    }
}

extension UITableView
{
    func reloadSections(_ sections: IndexSet, with animation: UITableView.RowAnimation, onCompletion: @escaping () -> ())
    {
        UIView.animate(withDuration: 0, animations: { [unowned self] in
            self.reloadSections(sections, with: animation)
        }) { _ in
            onCompletion()
        }
    }
}

extension Array where Element: Equatable
{
    mutating func appendUniquely(_ newElement: Element)
    {
        if !self.contains(where: { $0 == newElement })
        {
            self.append(newElement)
        }
    }
    
    mutating func removeUniquely(_ existingElement: Element)
    {
        self.removeAll(where: { $0 == existingElement })
    }
}

extension Array where Element == CategoricalSong
{
    subscript(_ category: Category) -> [Song]
    {
        get
        {
            return self.first(where: { $0.category == category })!.songs
        }
        set
        {
            let index = self.firstIndex(where: { $0.category == category })!
            self[index].songs = newValue
        }
    }
}

extension Numeric where Self: Comparable
{
    func constrain(lowerBound: Self, upperBound: Self) -> Self
    {
        return self < lowerBound ? lowerBound : (self > upperBound ? upperBound : self)
    }
}

extension UITableView
{
    func setGradientBackground(topColor: UIColor, bottomColor: UIColor)
    {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor, bottomColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.bounds
        let bView = UIView(frame: self.bounds)
        bView.layer.insertSublayer(gradientLayer, at: 0)
        self.backgroundView = bView
        print(topColor)
    }
}

extension UIScrollView
{
    var isBottomBouncing: Bool
    {
        return contentOffset.y > max(0.0, contentSize.height - bounds.height + adjustedContentInset.bottom)
    }
}

extension NSValueTransformerName
{
    static let customTransformer = NSValueTransformerName(rawValue: "CustomDataTransformer")
}
