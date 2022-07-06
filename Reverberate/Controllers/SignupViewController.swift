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
        return sView
    }()
    
    private let titleView: UILabel = {
        let tView = UILabel(useAutoLayout: true)
        tView.text = "Create a New Account"
        tView.textColor = .label
        tView.textAlignment = .center
        tView.font = .systemFont(ofSize: 34, weight: .bold)
        return tView
    }()
    
    private let nameField: UITextField = {
        let nField = UITextField()
        nField.enableAutoLayout()
        nField.backgroundColor = .systemFill.withAlphaComponent(0.15)
        nField.layer.cornerRadius = 5
        nField.layer.borderColor = UIColor(named: "techinessColor")!.withAlphaComponent(0.7).cgColor
        nField.placeholder = "Name"
        nField.clearButtonMode = .whileEditing
        nField.keyboardType = .namePhonePad
        nField.autocapitalizationType = .words
        nField.autocorrectionType = .no
        nField.borderStyle = .roundedRect
        return nField
    }()
    
    private let phoneField: UITextField = {
        let pField = UITextField()
        pField.enableAutoLayout()
        pField.backgroundColor = .systemFill.withAlphaComponent(0.15)
        pField.layer.cornerRadius = 5
        pField.layer.borderColor = UIColor(named: "techinessColor")!.withAlphaComponent(0.7).cgColor
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
        eField.backgroundColor = .systemFill.withAlphaComponent(0.15)
        eField.layer.cornerRadius = 5
        eField.layer.borderColor = UIColor(named: "techinessColor")!.withAlphaComponent(0.7).cgColor
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
        gLabel.font = .preferredFont(forTextStyle: .body)
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
        aField.backgroundColor = .systemFill.withAlphaComponent(0.15)
        aField.layer.cornerRadius = 5
        aField.layer.borderColor = UIColor(named: "techinessColor")!.withAlphaComponent(0.7).cgColor
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
        passField.backgroundColor = .systemFill.withAlphaComponent(0.15)
        passField.layer.cornerRadius = 5
        passField.layer.borderColor = UIColor(named: "techinessColor")!.withAlphaComponent(0.7).cgColor
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
            stackView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, constant: -view.bounds.width / 8),
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
        nameField.delegate = self
        phoneField.delegate = self
        ageField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
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
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        textField.layer.borderWidth = 1
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        textField.layer.borderWidth = 0
    }
}

extension SignupViewController
{
    @objc func onGenderSelection(_ sender: UISegmentedControl)
    {
        print(sender.selectedSegmentIndex)
    }
    
    @objc func onTextFieldFocus(_ sender: UITextField)
    {
        
    }
}
