//
//  OnboardingViewController.swift
//  Reverberate
//
//  Created by arun-13930 on 05/07/22.
//

import UIKit

class OnboardingViewController: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        //view.backgroundColor = UIColor(named: GlobalConstants.techinessColor)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        print("Onboarding View Controller")
    }
}
