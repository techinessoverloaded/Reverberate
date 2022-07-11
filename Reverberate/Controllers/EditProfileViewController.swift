//
//  EditProfileViewController.swift
//  Reverberate
//
//  Created by arun-13930 on 11/07/22.
//

import UIKit
import CoreData

class EditProfileViewController: UIViewController
{
    weak var userRef: User!
    
    private let contextSaveAction =  (UIApplication.shared.delegate as! AppDelegate).saveContext
    
    override func loadView()
    {
        super.loadView()
        title = "Edit Profile"
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
}
