//
//  SampleVCViewController.swift
//  Reverberate
//
//  Created by arun-13930 on 19/04/23.
//

import UIKit

protocol ThemeCustomizable: AnyObject {
    func appThemeChanged(_ notification: Notification)
}

extension ThemeCustomizable {
    
    /// Call in viewDidLoad()
    func registerThemeNotifications() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name("ThemeChanged"), object: nil, queue: .main, using: { [weak self] notification in
            if let _self = self {
                _self.appThemeChanged(notification)
            }
        })
    }
    
    /// Call in deinit()
    func removeThemeNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("ThemeChanged"), object: nil)
    }
}

extension UIViewController: ThemeCustomizable {
    @objc func appThemeChanged(_ notification: Notification) {
        print("App Theme Changed")
    }
}
