//
//  CustomDataTransformer.swift
//  Reverberate
//
//  Created by arun-13930 on 08/09/22.
//

import UIKit

class CustomDataTransformer: ValueTransformer
{
    override class func allowsReverseTransformation() -> Bool
    {
        return true
    }
    
    override class func transformedValueClass() -> AnyClass
    {
        return NSData.self
    }
    
    override func transformedValue(_ value: Any?) -> Any?
    {
        guard let object = value as? NSArray else
        {
            fatalError("object to be written is of type: \(type(of: value))")
        }
        return try? NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: true)
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any?
    {
        guard let data = value as? Data else
        {
            fatalError("value is of type: \(type(of: value))")
        }
        return try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, Song.self, NSURL.self, Artist.self, UIImage.self, Playlist.self, Album.self, NSDate.self, NSString.self, NSNumber.self], from: data)
    }
}
