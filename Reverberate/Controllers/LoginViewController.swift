//
//  LoginViewController.swift
//  Reverberate
//
//  Created by arun-13930 on 05/07/22.
//

import UIKit

class LoginViewController: UITableViewController
{
    private let titleView: UILabel = {
        let tView = UILabel(useAutoLayout: true)
        tView.text = "Welcome back"
        tView.textColor = .label
        tView.textAlignment = .center
        tView.font = .systemFont(ofSize: 34, weight: .bold)
        return tView
    }()
    
    private let emailCumPhoneField: UITextField = {
        let epField = UITextField()
        epField.enableAutoLayout()
        epField.backgroundColor = .systemFill.withAlphaComponent(0.15)
        epField.layer.cornerRadius = 10
        epField.layer.borderColor = UIColor(named: "techinessColor")!.withAlphaComponent(0.7).cgColor
        //Changeable Property
        epField.placeholder = "Email Address"
        epField.clearButtonMode = .whileEditing
        //Changeable Property
        epField.keyboardType = .emailAddress
        epField.autocapitalizationType = .none
        epField.borderStyle = .roundedRect
        return epField
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
    
    private let emailOrPhoneSelector: UISegmentedControl = {
        let ePSelector = UISegmentedControl(items: ["Email", "Phone"])
        return ePSelector
    }()
    
    private let loginButton: UIButton = {
        var lButtonConfig = UIButton.Configuration.filled()
        lButtonConfig.cornerStyle = .dynamic
        lButtonConfig.title = "Login"
        lButtonConfig.baseBackgroundColor = .init(named: "techinessColor")
        let lButton = UIButton(configuration: lButtonConfig)
        lButton.layer.cornerRadius = 10
        return lButton
    }()
    
    private let noAccountButton: UIButton = {
        var nButtonConfig = UIButton.Configuration.borderless()
        nButtonConfig.title = "Nah, I don't have an Account!"
        nButtonConfig.baseForegroundColor = .init(named: "techinessColor")
        let aButton = UIButton(configuration: nButtonConfig)
        return aButton
    }()
    
    override func loadView()
    {
        super.loadView()
        tableView.register(FormTableViewCell.self, forCellReuseIdentifier: FormTableViewCell.identifier)
        tableView.allowsSelection = false
        tableView.keyboardDismissMode = .onDrag
        tableView.cellLayoutMarginsFollowReadableWidth = true
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        emailOrPhoneSelector.selectedSegmentIndex = 0
        emailOrPhoneSelector.selectedSegmentTintColor = UIColor(named: "techinessColor")
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        emailOrPhoneSelector.setTitleTextAttributes(titleTextAttributes, for: .selected)
        emailCumPhoneField.delegate = self
        passwordField.delegate = self
        emailCumPhoneField.becomeFirstResponder()
        emailOrPhoneSelector.addTarget(self, action: #selector(onEmailPhoneSelectionChange(_:)), for: .valueChanged)
        loginButton.addTarget(self, action: #selector(onLoginButtonTap(_:)), for: .touchUpInside)
        noAccountButton.addTarget(self, action: #selector(onNoAccountButtonTap(_:)), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        print("Login View Controller")
    }
}

extension LoginViewController: UITextFieldDelegate
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
        if textField === emailCumPhoneField
        {
            return passwordField.becomeFirstResponder()
        }
        else
        {
            loginButton.sendActions(for: .touchUpInside)
            return passwordField.resignFirstResponder()
        }
    }
}

// TableView Delegate and DataSource
extension LoginViewController
{
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        6
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: FormTableViewCell.identifier, for: indexPath) as! FormTableViewCell
        switch indexPath.section
        {
        case 0:
            cell.addSubViewToContentView(titleView)
            return cell
        case 1:
            cell.addSubViewToContentView(emailOrPhoneSelector)
            return cell
        case 2:
            cell.addSubViewToContentView(emailCumPhoneField)
            return cell
        case 3:
            cell.addSubViewToContentView(passwordField)
            return cell
        case 4:
            cell.addSubViewToContentView(loginButton)
            return cell
        case 5:
            cell.addSubViewToContentView(noAccountButton)
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension LoginViewController
{
    @objc func onEmailPhoneSelectionChange(_ sender: UISegmentedControl)
    {
        emailCumPhoneField.resignFirstResponder()
        emailCumPhoneField.text = ""
        let selectedIndex = sender.selectedSegmentIndex
        if selectedIndex == 0
        {
            if emailCumPhoneField.placeholder == "Phone Number"
            {
                emailCumPhoneField.placeholder = "Email Address"
                emailCumPhoneField.keyboardType = .emailAddress
            }
        }
        else
        {
            if emailCumPhoneField.placeholder == "Email Address"
            {
                emailCumPhoneField.placeholder = "Phone Number"
                emailCumPhoneField.keyboardType = .phonePad
            }
        }
        emailCumPhoneField.becomeFirstResponder()
    }
    
    @objc func onLoginButtonTap(_ sender: UIButton)
    {
        print("Logging in...")
    }
    
    @objc func onNoAccountButtonTap(_ sender: UIButton)
    {
        (UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate).changeRootViewController(SignupViewController(style: .insetGrouped))
        print("Moving on to Signup Screen...")
    }
}
