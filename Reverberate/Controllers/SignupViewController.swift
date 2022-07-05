//
//  SignupViewController.swift
//  Reverberate
//
//  Created by arun-13930 on 05/07/22.
//

import UIKit

class SignupViewController: UIViewController
{
    private var safeArea: UILayoutGuide!
    
    private let stackView: UIStackView = {
        let sView = UIStackView(useAutoLayout: true)
        sView.backgroundColor = .clear
        sView.layer.cornerRadius = 20
        sView.axis = .vertical
        sView.distribution = .equalCentering
        sView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        sView.isLayoutMarginsRelativeArrangement = true
        //sView.spacing = 20
        return sView
    }()
    
    private let titleView: UILabel = {
        let tView = UILabel(useAutoLayout: true)
        tView.text = "Create a New Account"
        tView.textColor = .label
        tView.font = .systemFont(ofSize: 34, weight: .bold)
        return tView
    }()
    
    private let nameField: UITextField = {
        let nField = UITextField()
        nField.enableAutoLayout()
        nField.backgroundColor = .white.withAlphaComponent(0.2)
        nField.placeholder = "Name"
        nField.clearButtonMode = .whileEditing
        nField.keyboardType = .namePhonePad
        nField.autocapitalizationType = .words
        nField.borderStyle = .roundedRect
        return nField
    }()
    
    private let phoneField: UITextField = {
        let pField = UITextField()
        pField.enableAutoLayout()
        pField.backgroundColor = .white.withAlphaComponent(0.2)
        pField.placeholder = "Phone Number"
        pField.clearButtonMode = .whileEditing
        pField.keyboardType = .phonePad
        pField.autocapitalizationType = .none
        pField.borderStyle = .roundedRect
        return pField
    }()
    
    private let emailField: UITextField = {
        let eField = UITextField()
        eField.enableAutoLayout()
        eField.backgroundColor = .white.withAlphaComponent(0.2)
        eField.placeholder = "Email Address"
        eField.clearButtonMode = .whileEditing
        eField.keyboardType = .emailAddress
        eField.autocapitalizationType = .none
        eField.borderStyle = .roundedRect
        return eField
    }()
    
    private let genderRegion: UIStackView = {
        let gRegion = UIStackView(useAutoLayout: true)
        gRegion.backgroundColor = .clear
        gRegion.axis = .vertical
        gRegion.spacing = 10
        return gRegion
    }()
    
    private let genderLabel: UILabel = {
        let gLabel = UILabel(useAutoLayout: true)
        gLabel.text = "Pick your Gender"
        gLabel.textColor = .label
        return gLabel
    }()

    private let genderSegmenter: UISegmentedControl = {
        let gSegmenter = UISegmentedControl(items: ["Male", "Female", "Others"])
        gSegmenter.enableAutoLayout()
        return gSegmenter
    }()
    
    private let ageField: UITextField = {
        let aField = UITextField()
        aField.enableAutoLayout()
        aField.backgroundColor = .white.withAlphaComponent(0.2)
        aField.placeholder = "Age"
        aField.clearButtonMode = .whileEditing
        aField.keyboardType = .numberPad
        aField.autocapitalizationType = .none
        aField.borderStyle = .roundedRect
        return aField
    }()
    
    private let passwordField: UITextField = {
        let passField = UITextField()
        passField.enableAutoLayout()
        passField.backgroundColor = .white.withAlphaComponent(0.2)
        passField.placeholder = "Password"
        passField.isSecureTextEntry = true
        passField.clearButtonMode = .whileEditing
        passField.keyboardType = .default
        passField.autocapitalizationType = .none
        passField.borderStyle = .roundedRect
        return passField
    }()
    
    private let signupButton: UIButton = {
        var sButtonConfig = UIButton.Configuration.filled()
        sButtonConfig.cornerStyle = .capsule
        sButtonConfig.title = "Signup"
        sButtonConfig.baseBackgroundColor = .init(named: "techinessColor")
        let sButton = UIButton(configuration: sButtonConfig)
        return sButton
    }()
    
    private let accountExistsButton: UIButton = {
        var aButtonConfig = UIButton.Configuration.borderless()
        aButtonConfig.title = "I have an Account already!"
        aButtonConfig.baseForegroundColor = .init(named: "techinessColor")
        let aButton = UIButton(configuration: aButtonConfig)
        return aButton
    }()
    
    override func loadView()
    {
        super.loadView()
        safeArea = view.safeAreaLayoutGuide
        view.addSubview(stackView)
        //view.addSubview(titleView)
        stackView.addArrangedSubview(titleView)
        stackView.addArrangedSubview(nameField)
        stackView.addArrangedSubview(ageField)
        genderRegion.addArrangedSubview(genderLabel)
        genderRegion.addArrangedSubview(genderSegmenter)
        stackView.addArrangedSubview(genderRegion)
        stackView.addArrangedSubview(phoneField)
        stackView.addArrangedSubview(emailField)
        stackView.addArrangedSubview(passwordField)
        stackView.addArrangedSubview(signupButton)
        stackView.addArrangedSubview(accountExistsButton)
        NSLayoutConstraint.activate([
            //titleView.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -25),
            //titleView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            stackView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.9),
            stackView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, constant: -50),
            stackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
        ])
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        genderSegmenter.selectedSegmentIndex = 0
        genderSegmenter.addTarget(self, action: #selector(onGenderSelection(_:)), for: .valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        print("Signup View Controller")
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        stackView.layer.shadowPath = UIBezierPath(rect: stackView.bounds).cgPath
    }
}

extension SignupViewController: UITextFieldDelegate
{
    
}

extension SignupViewController
{
    @objc func onGenderSelection(_ sender: UISegmentedControl)
    {
        print(sender.selectedSegmentIndex)
    }
}
