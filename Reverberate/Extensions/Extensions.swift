//
//  Extensions.swift
//  Reverberate
//
//  Created by arun-13930 on 05/07/22.
//

import UIKit

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
}
