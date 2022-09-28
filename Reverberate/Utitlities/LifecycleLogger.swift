//
//  LifecycleLogger.swift
//  Reverberate
//
//  Created by arun-13930 on 26/09/22.
//

import UIKit

struct LifecycleLogger
{
    //Prevent Instantiation
    private init() {}
    
    private static func getDescription(_ object: AnyObject) -> String
    {
        let nameWithAddress = String(describing: object)
        guard let indexOfColon = nameWithAddress.firstIndex(of: ":") else
        {
            return String(describing: object)
        }
        guard let indexOfAngularBracket = nameWithAddress.firstIndex(of: ">") else
        {
            return String(describing: object)
        }
        let address = String( nameWithAddress[nameWithAddress.index(after: indexOfColon)...nameWithAddress.index(before: indexOfAngularBracket)])
        return "\(String(describing: type(of: object))):\(address)"
    }
    
    static func deinitLog(_ object: AnyObject)
    {
        print("\(getDescription(object)) is being deallocated")
    }
    
    static func viewDidAppearLog(_ viewController: UIViewController)
    {
        print("\(getDescription(viewController)) Did Appear")
    }
    
    static func viewWillAppearLog(_ viewController: UIViewController)
    {
        print("\(getDescription(viewController)) Will Appear")
    }
    
    static func viewDidDisappearLog(_ viewController: UIViewController)
    {
        print("\(getDescription(viewController)) Did Disappear")
    }
    
    static func viewWillDisappearLog(_ viewController: UIViewController)
    {
        print("\(getDescription(viewController)) Will Disappear")
    }
}
