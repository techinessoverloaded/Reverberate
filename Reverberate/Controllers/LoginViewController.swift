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
        tView.text = "Login"
        tView.textColor = .label
        tView.textAlignment = .center
        tView.numberOfLines = 0
        tView.font = .systemFont(ofSize: 34, weight: .bold)
        return tView
    }()
    
    private let emailCumPhoneField: UITextField = {
        let epField = UITextField()
        epField.enableAutoLayout()
        epField.backgroundColor = .systemFill.withAlphaComponent(0.15)
        epField.layer.cornerRadius = 10
        epField.layer.borderColor = UIColor(named: GlobalConstants.techinessColor)!.withAlphaComponent(0.7).cgColor
        //Changeable Property
        epField.placeholder = "Email Address"
        epField.clearButtonMode = .whileEditing
        epField.clearsOnBeginEditing = false
        //Changeable Property
        epField.keyboardType = .emailAddress
        epField.returnKeyType = .next
        epField.autocapitalizationType = .none
        //Changeable Property
        epField.textContentType = .emailAddress
        epField.borderStyle = .roundedRect
        epField.enablesReturnKeyAutomatically = true
        return epField
    }()
    
    private let passwordField: UITextField = {
        let passField = UITextField()
        passField.enableAutoLayout()
        passField.backgroundColor = .systemFill.withAlphaComponent(0.15)
        passField.layer.cornerRadius = 10
        passField.layer.borderColor = UIColor(named: GlobalConstants.techinessColor)!.withAlphaComponent(0.7).cgColor
        passField.placeholder = "Password"
        passField.isSecureTextEntry = true
        passField.clearButtonMode = .whileEditing
        passField.clearsOnBeginEditing = false
        passField.keyboardType = .default
        passField.returnKeyType = .done
        passField.textContentType = .oneTimeCode
        passField.autocapitalizationType = .none
        passField.borderStyle = .roundedRect
        passField.enablesReturnKeyAutomatically = true
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
        lButtonConfig.baseBackgroundColor = .init(named: GlobalConstants.techinessColor)
        let lButton = UIButton(configuration: lButtonConfig)
        lButton.layer.cornerRadius = 10
        return lButton
    }()
    
    private let noAccountButton: UIButton = {
        var nButtonConfig = UIButton.Configuration.borderless()
        nButtonConfig.title = "Nah, I don't have an Account!"
        nButtonConfig.baseForegroundColor = .init(named: GlobalConstants.techinessColor)
        let aButton = UIButton(configuration: nButtonConfig)
        return aButton
    }()
    
    private let emailCumPhoneErrorLabel: UILabel = {
        let epErrorLabel = UILabel(useAutoLayout: false)
        epErrorLabel.textColor = .systemRed
        epErrorLabel.font = .preferredFont(forTextStyle: .footnote)
        epErrorLabel.text = "Required"
        epErrorLabel.textAlignment = .right
        return epErrorLabel
    }()
    
    private let passwordErrorLabel: UILabel = {
        let passErrorLabel = UILabel(useAutoLayout: false)
        passErrorLabel.textColor = .systemRed
        passErrorLabel.font = .preferredFont(forTextStyle: .footnote)
        passErrorLabel.text = "Required"
        passErrorLabel.textAlignment = .right
        return passErrorLabel
    }()
    
    private var headerView: UIView!
    
    private lazy var defaultOffset: CGFloat = tableView.contentOffset.y
    
    private var tableHeaderHeight: CGFloat = 70
    
    weak var delegate: LoginDelegate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        title = "Login"
        navigationItem.title = nil
        view.backgroundColor = .systemBackground
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        tableView.allowsSelection = false
        tableView.keyboardDismissMode = .onDrag
        tableView.cellLayoutMarginsFollowReadableWidth = true
        emailOrPhoneSelector.selectedSegmentIndex = 0
        emailOrPhoneSelector.selectedSegmentTintColor = UIColor(named: GlobalConstants.techinessColor)
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        emailOrPhoneSelector.setTitleTextAttributes(titleTextAttributes, for: .selected)
        emailCumPhoneField.delegate = self
        passwordField.delegate = self
        emailOrPhoneSelector.addTarget(self, action: #selector(onEmailPhoneSelectionChange(_:)), for: .valueChanged)
        loginButton.addTarget(self, action: #selector(onLoginButtonTap(_:)), for: .touchUpInside)
        noAccountButton.addTarget(self, action: #selector(onNoAccountButtonTap(_:)), for: .touchUpInside)
        emailCumPhoneErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
        headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.contentSize.width, height: tableHeaderHeight))
        headerView.addSubview(titleView)
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: headerView.topAnchor),
            titleView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor)
        ])
        tableView.tableHeaderView = headerView
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        emailCumPhoneField.becomeFirstResponder()
        print("Login View Controller")
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        guard let cancelButton = navigationItem.leftBarButtonItem else
        {
            print("no cancel button")
            return
        }
        let _ = cancelButton.target?.perform(cancelButton.action!, with: nil)
        super.viewDidDisappear(animated)
    }
    
    deinit
    {
        LifecycleLogger.deinitLog(self)
    }
}

extension LoginViewController: UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        textField.layer.borderColor = UIColor(named: GlobalConstants.techinessColor)!.cgColor
        textField.layer.borderWidth = 2
        if textField === emailCumPhoneField
        {
            emailCumPhoneErrorLabel.isHidden = true
        }
        else
        {
            passwordErrorLabel.isHidden = true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField.isInvalid
        {
            textField.layer.borderColor = UIColor(named: GlobalConstants.techinessColor)!.cgColor
            if textField === emailCumPhoneField
            {
                emailCumPhoneErrorLabel.isHidden = true
            }
            else
            {
                passwordErrorLabel.isHidden = true
            }
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField === emailCumPhoneField
        {
            if emailOrPhoneSelector.selectedSegmentIndex == 0
            {
                var email = textField.text ?? ""
                email.trim()
                if !email.isEmpty
                {
                    if !InputValidator.validateEmail(email)
                    {
                        textField.isInvalid = true
                        emailCumPhoneErrorLabel.text = "Entered Email Address is Invalid !"
                        emailCumPhoneErrorLabel.isHidden = false
                    }
                    else
                    {
                        textField.isInvalid = false
                        emailCumPhoneErrorLabel.isHidden = true
                    }
                }
                else
                {
                    textField.isInvalid = false
                    emailCumPhoneErrorLabel.isHidden = true
                }
            }
            else
            {
                var phone = textField.text ?? ""
                phone.trim()
                if !phone.isEmpty
                {
                    if !InputValidator.validatePhone(phone)
                    {
                        textField.isInvalid = true
                        emailCumPhoneErrorLabel.text = "Entered Phone Number is Invalid !"
                        emailCumPhoneErrorLabel.isHidden = false
                    }
                    else
                    {
                        textField.isInvalid = false
                        emailCumPhoneErrorLabel.isHidden = true
                    }
                }
                else
                {
                    textField.isInvalid = false
                    emailCumPhoneErrorLabel.isHidden = true
                }
            }
        }
        else
        {
            textField.isInvalid = false
            passwordErrorLabel.isHidden = true
        }
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
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        switch section
        {
        case 1:
            return emailCumPhoneErrorLabel
        case 2:
            return passwordErrorLabel
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 34
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as! CustomTableViewCell
        let section = indexPath.section
        if section == 0
        {
            cell.addSubViewToContentView(emailOrPhoneSelector)
        }
        else if section == 1
        {
            cell.addSubViewToContentView(emailCumPhoneField)
        }
        else if section == 2
        {
            cell.addSubViewToContentView(passwordField)
        }
        else if section == 3
        {
            cell.addSubViewToContentView(loginButton)
        }
        else
        {
            cell.addSubViewToContentView(noAccountButton)
        }
        return cell
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
                emailCumPhoneField.textContentType = .emailAddress
                if UIDevice.current.userInterfaceIdiom == .phone
                {
                    emailCumPhoneField.removeReturnButtonFromKeyboard()
                }
            }
        }
        else
        {
            if emailCumPhoneField.placeholder == "Email Address"
            {
                emailCumPhoneField.placeholder = "Phone Number"
                emailCumPhoneField.keyboardType = .phonePad
                emailCumPhoneField.textContentType = .telephoneNumber
                if UIDevice.current.userInterfaceIdiom == .phone
                {
                    emailCumPhoneField.addReturnButtonToKeyboard(target: self, action: #selector(onCustomReturnButtonTap(_:)), title: "next")
                }
            }
        }
        emailCumPhoneField.isInvalid = false
        emailCumPhoneErrorLabel.isHidden = true
        emailCumPhoneField.becomeFirstResponder()
    }
    
    @objc func onLoginButtonTap(_ sender: UIButton)
    {
        if emailCumPhoneField.text?.isEmpty ?? true
        {
            emailCumPhoneField.isInvalid = true
            emailCumPhoneErrorLabel.text = "Required"
            emailCumPhoneErrorLabel.isHidden = false
        }
        else
        {
            textFieldDidEndEditing(emailCumPhoneField)
        }
        if passwordField.text?.isEmpty ?? true
        {
            passwordField.isInvalid = true
            passwordErrorLabel.isHidden = false
        }
        if !emailCumPhoneField.isInvalid && !passwordField.isInvalid
        {
            var user: User?
            if emailOrPhoneSelector.selectedSegmentIndex == 0
            {
                let email = emailCumPhoneField.text!.trimmedCopy()
                let password = passwordField.text!.trimmedCopy()
                user = SessionManager.shared.validateUser(email: email, password: password)
            }
            else
            {
                let phone = emailCumPhoneField.text!.trimmedCopy()
                let password = passwordField.text!.trimmedCopy()
                user = SessionManager.shared.validateUser(phone: phone, password: password)
            }
            if user != nil
            {
                loginButton.configuration?.showsActivityIndicator = true
                print("Logging in...")
                SessionManager.shared.loginUser(user!)
                loginButton.configuration?.showsActivityIndicator = false
                delegate?.onSuccessfulLogin()
            }
            else
            {
                delegate?.onLoginFailure()
            }
        }
    }
    
    @objc func onNoAccountButtonTap(_ sender: UIButton)
    {
        delegate?.onNoAccountButtonTap()
    }
    
    @objc func onCustomReturnButtonTap(_ sender: UIBarButtonItem)
    {
        if emailCumPhoneField.isFirstResponder
        {
            passwordField.becomeFirstResponder()
        }
        print("Custom Return Button Tapped")
    }
}

extension LoginViewController
{
    override func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        let offset = tableView.contentOffset.y
        UIView.animate(withDuration: 0.1, delay: 0, options: [.transitionCrossDissolve], animations: { [unowned self] in
            navigationItem.title = offset > defaultOffset ? title : nil
            titleView.alpha = offset > defaultOffset ? 0 : 1
        }, completion: nil)
    }
}
