//
//  SignupViewController.swift
//  Reverberate
//
//  Created by arun-13930 on 05/07/22.
//

import UIKit

class SignupViewController: UITableViewController
{
    private var safeArea: UILayoutGuide!
    
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
        nField.layer.cornerRadius = 10
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
        pField.layer.cornerRadius = 10
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
        eField.layer.cornerRadius = 10
        eField.layer.borderColor = UIColor(named: "techinessColor")!.withAlphaComponent(0.7).cgColor
        eField.placeholder = "Email Address"
        eField.clearButtonMode = .whileEditing
        eField.keyboardType = .emailAddress
        eField.autocapitalizationType = .none
        eField.borderStyle = .roundedRect
        return eField
    }()
        
    private let passwordField: UITextField = {
        let passField = UITextField()
        passField.enableAutoLayout()
        passField.backgroundColor = .systemFill.withAlphaComponent(0.15)
        passField.layer.cornerRadius = 10
        passField.layer.borderColor = UIColor(named: "techinessColor")!.withAlphaComponent(0.7).cgColor
        passField.placeholder = "Password"
        passField.isSecureTextEntry = true
        passField.clearButtonMode = .whileEditing
        passField.keyboardType = .default
        passField.autocapitalizationType = .none
        passField.borderStyle = .roundedRect
        return passField
    }()
    
    private let confirmPasswordField: UITextField = {
        let pass2Field = UITextField()
        pass2Field.enableAutoLayout()
        pass2Field.backgroundColor = .systemFill.withAlphaComponent(0.15)
        pass2Field.layer.cornerRadius = 10
        pass2Field.layer.borderColor = UIColor(named: "techinessColor")!.withAlphaComponent(0.7).cgColor
        pass2Field.placeholder = "Confirm Password"
        pass2Field.isSecureTextEntry = true
        pass2Field.clearButtonMode = .whileEditing
        pass2Field.keyboardType = .default
        pass2Field.autocapitalizationType = .none
        pass2Field.borderStyle = .roundedRect
        return pass2Field
    }()
    
    private let signupButton: UIButton = {
        var sButtonConfig = UIButton.Configuration.filled()
        sButtonConfig.cornerStyle = .dynamic
        sButtonConfig.title = "Sign up"
        sButtonConfig.baseBackgroundColor = .init(named: "techinessColor")
        let sButton = UIButton(configuration: sButtonConfig)
        sButton.layer.cornerRadius = 10
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
        tableView.register(SignupTableViewCell.self, forCellReuseIdentifier: SignupTableViewCell.identifier)
        tableView.allowsSelection = false
        tableView.keyboardDismissMode = .onDrag
        tableView.cellLayoutMarginsFollowReadableWidth = true
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        nameField.delegate = self
        phoneField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        confirmPasswordField.delegate = self
        signupButton.addTarget(self, action: #selector(onSignupButtonTap(_:)), for: .touchUpInside)
        accountExistsButton.addTarget(self, action: #selector(onExistingAccountButtonTap(_:)), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        print("Signup View Controller")
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
    }
}

extension SignupViewController: UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        textField.layer.borderWidth = 2
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        textField.layer.borderWidth = 0
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField === nameField
        {
            return phoneField.becomeFirstResponder()
        }
        else if textField === phoneField
        {
            return emailField.becomeFirstResponder()
        }
        else if textField === emailField
        {
            return passwordField.becomeFirstResponder()
        }
        else if textField === passwordField
        {
            return confirmPasswordField.becomeFirstResponder()
        }
        else
        {
            signupButton.sendActions(for: .touchUpInside)
            return confirmPasswordField.resignFirstResponder()
        }
    }
}

// TableView Delegate and Datasource
extension SignupViewController
{
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        8
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: SignupTableViewCell.identifier, for: indexPath) as! SignupTableViewCell
        switch indexPath.section
        {
        case 0:
            cell.addSubViewToContentView(titleView)
            return cell
        case 1:
            cell.addSubViewToContentView(nameField)
            return cell
        case 2:
            cell.addSubViewToContentView(phoneField)
            return cell
        case 3:
            cell.addSubViewToContentView(emailField)
            return cell
        case 4:
            cell.addSubViewToContentView(passwordField)
            return cell
        case 5:
            cell.addSubViewToContentView(confirmPasswordField)
            return cell
        case 6:
            cell.addSubViewToContentView(signupButton)
            return cell
        case 7:
            cell.addSubViewToContentView(accountExistsButton)
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension SignupViewController
{
    @objc func onSignupButtonTap(_ sender: UIButton)
    {
        print("Signing up...")
    }
    
    @objc func onExistingAccountButtonTap(_ sender: UIButton)
    {
        print("Moving on to Login Screen...")
        (UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate).changeRootViewController(LoginViewController())
    }
}
