//
//  CustomDataTransformer.swift
//  Reverberate
//
//  Created by arun-13930 on 08/09/22.
//

import UIKit

class CustomDataTransformer: NSSecureUnarchiveFromDataTransformer
{
    override class var allowedTopLevelClasses: [AnyClass]
    {
        return [NSArray.self, Song.self, NSURL.self, Artist.self, UIImage.self, Playlist.self ,Album.self, NSDate.self, NSString.self, NSNumber.self]
    }
    
    override class func allowsReverseTransformation() -> Bool
    {
        return true
    }
    
    override class func transformedValueClass() -> AnyClass
    {
        return NSArray.self
    }
}
