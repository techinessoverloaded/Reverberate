//
//  SignupViewController.swift
//  Reverberate
//
//  Created by arun-13930 on 05/07/22.
//

import UIKit

class SignupViewController: UITableViewController
{
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
        nField.layer.borderColor = UIColor(named: GlobalConstants.techinessColor)!.withAlphaComponent(0.7).cgColor
        nField.placeholder = "Name"
        nField.clearButtonMode = .whileEditing
        nField.clearsOnBeginEditing = false
        nField.keyboardType = .namePhonePad
        nField.returnKeyType = .next
        nField.autocapitalizationType = .words
        nField.autocorrectionType = .no
        nField.textContentType = .name
        nField.borderStyle = .roundedRect
        nField.enablesReturnKeyAutomatically = true
        return nField
    }()
    
    private let phoneField: UITextField = {
        let pField = UITextField()
        pField.enableAutoLayout()
        pField.backgroundColor = .systemFill.withAlphaComponent(0.15)
        pField.layer.cornerRadius = 10
        pField.layer.borderColor = UIColor(named: GlobalConstants.techinessColor)!.withAlphaComponent(0.7).cgColor
        pField.placeholder = "Phone Number"
        pField.clearButtonMode = .whileEditing
        pField.clearsOnBeginEditing = false
        pField.keyboardType = .phonePad
        pField.returnKeyType = .next
        pField.autocapitalizationType = .none
        pField.textContentType = .telephoneNumber
        pField.borderStyle = .roundedRect
        pField.enablesReturnKeyAutomatically = true
        return pField
    }()
    
    private let emailField: UITextField = {
        let eField = UITextField()
        eField.enableAutoLayout()
        eField.backgroundColor = .systemFill.withAlphaComponent(0.15)
        eField.layer.cornerRadius = 10
        eField.layer.borderColor = UIColor(named: GlobalConstants.techinessColor)!.withAlphaComponent(0.7).cgColor
        eField.placeholder = "Email Address"
        eField.clearButtonMode = .whileEditing
        eField.clearsOnBeginEditing = false
        eField.keyboardType = .emailAddress
        eField.returnKeyType = .next
        eField.autocapitalizationType = .none
        eField.textContentType = .emailAddress
        eField.borderStyle = .roundedRect
        eField.enablesReturnKeyAutomatically = true
        return eField
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
        passField.textContentType = .oneTimeCode
        passField.returnKeyType = .next
        passField.autocapitalizationType = .none
        passField.borderStyle = .roundedRect
        passField.enablesReturnKeyAutomatically = true
        return passField
    }()
    
    private let confirmPasswordField: UITextField = {
        let pass2Field = UITextField()
        pass2Field.enableAutoLayout()
        pass2Field.backgroundColor = .systemFill.withAlphaComponent(0.15)
        pass2Field.layer.cornerRadius = 10
        pass2Field.layer.borderColor = UIColor(named: GlobalConstants.techinessColor)!.withAlphaComponent(0.7).cgColor
        pass2Field.placeholder = "Confirm Password"
        pass2Field.isSecureTextEntry = true
        pass2Field.clearButtonMode = .whileEditing
        pass2Field.clearsOnBeginEditing = false
        pass2Field.keyboardType = .default
        pass2Field.textContentType = .oneTimeCode
        pass2Field.returnKeyType = .done
        pass2Field.autocapitalizationType = .none
        pass2Field.borderStyle = .roundedRect
        pass2Field.enablesReturnKeyAutomatically = true
        return pass2Field
    }()
    
    private let signupButton: UIButton = {
        var sButtonConfig = UIButton.Configuration.filled()
        sButtonConfig.cornerStyle = .dynamic
        sButtonConfig.title = "Sign up"
        sButtonConfig.baseBackgroundColor = .init(named: GlobalConstants.techinessColor)
        let sButton = UIButton(configuration: sButtonConfig)
        sButton.layer.cornerRadius = 10
        return sButton
    }()
    
    private let accountExistsButton: UIButton = {
        var aButtonConfig = UIButton.Configuration.borderless()
        aButtonConfig.title = "I have an Account already!"
        aButtonConfig.baseForegroundColor = .init(named: GlobalConstants.techinessColor)
        let aButton = UIButton(configuration: aButtonConfig)
        return aButton
    }()
    
    private let nameErrorLabel: UILabel = {
        let nErrorLabel = UILabel(useAutoLayout: false)
        nErrorLabel.textColor = .systemRed
        nErrorLabel.font = .preferredFont(forTextStyle: .footnote)
        nErrorLabel.text = "Required"
        nErrorLabel.textAlignment = .right
        return nErrorLabel
    }()
    
    private let phoneErrorLabel: UILabel = {
        let pErrorLabel = UILabel(useAutoLayout: false)
        pErrorLabel.textColor = .systemRed
        pErrorLabel.font = .preferredFont(forTextStyle: .footnote)
        pErrorLabel.text = "Required"
        pErrorLabel.textAlignment = .right
        return pErrorLabel
    }()
    
    private let emailErrorLabel: UILabel = {
        let eErrorLabel = UILabel(useAutoLayout: false)
        eErrorLabel.textColor = .systemRed
        eErrorLabel.font = .preferredFont(forTextStyle: .footnote)
        eErrorLabel.text = "Required"
        eErrorLabel.textAlignment = .right
        return eErrorLabel
    }()
    
    private let passwordErrorLabel: UILabel = {
        let passErrorLabel = UILabel(useAutoLayout: false)
        passErrorLabel.textColor = .systemRed
        passErrorLabel.font = .preferredFont(forTextStyle: .footnote)
        passErrorLabel.text = "Required"
        passErrorLabel.textAlignment = .right
        passErrorLabel.lineBreakMode = .byWordWrapping
        passErrorLabel.numberOfLines = 2
        return passErrorLabel
    }()
    
    private let confirmPasswordErrorLabel: UILabel = {
        let cpErrorLabel = UILabel(useAutoLayout: false)
        cpErrorLabel.textColor = .systemRed
        cpErrorLabel.font = .preferredFont(forTextStyle: .footnote)
        cpErrorLabel.text = "Required"
        cpErrorLabel.textAlignment = .right
        return cpErrorLabel
    }()
    
    private let contentBlurView: CustomVisualEffectView =
    {
        let cbView = CustomVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterial), intensity: 0.5)
        cbView.enableAutoLayout()
        return cbView
    }()
    
    private var newUser: User?
    
    private var languageSelectionController: LanguageSelectionCollectionViewController!
    
    private var headerView: UIView!
    
    private lazy var defaultOffset: CGFloat = tableView.contentOffset.y
    
    private var tableHeaderHeight: CGFloat = 70
    
    weak var delegate: SignupDelegate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        title = "Create a New Account"
        navigationItem.title = nil
        view.backgroundColor = .systemBackground
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        tableView.allowsSelection = false
        tableView.keyboardDismissMode = .onDrag
        tableView.cellLayoutMarginsFollowReadableWidth = true
        nameField.delegate = self
        phoneField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        confirmPasswordField.delegate = self
        signupButton.addTarget(self, action: #selector(onSignupButtonTap(_:)), for: .touchUpInside)
        accountExistsButton.addTarget(self, action: #selector(onExistingAccountButtonTap(_:)), for: .touchUpInside)
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            phoneField.addReturnButtonToKeyboard(target: self, action: #selector(onCustomReturnButtonTap(_:)), title: "next")
        }
        nameErrorLabel.isHidden = true
        phoneErrorLabel.isHidden = true
        emailErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
        confirmPasswordErrorLabel.isHidden = true
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
        nameField.becomeFirstResponder()
        print("Signup View Controller")
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
    }
    
    func activateContentBlurViewConstraints()
    {
        self.view.insertSubview(contentBlurView, aboveSubview: tableView)
        NSLayoutConstraint.activate([
            contentBlurView.heightAnchor.constraint(equalTo: view.heightAnchor),
            contentBlurView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
}

extension SignupViewController: UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        textField.layer.borderColor = UIColor(named: GlobalConstants.techinessColor)!.cgColor
        textField.layer.borderWidth = 2
        if textField === nameField
        {
            nameErrorLabel.isHidden = true
        }
        else if textField === phoneField
        {
            phoneErrorLabel.isHidden = true
        }
        else if textField === emailField
        {
            emailErrorLabel.isHidden = true
        }
        else if textField === passwordField
        {
            passwordErrorLabel.isHidden = true
        }
        else
        {
            confirmPasswordErrorLabel.isHidden = true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField.isInvalid
        {
            textField.layer.borderColor = UIColor(named: GlobalConstants.techinessColor)!.cgColor
            if textField === nameField
            {
                nameErrorLabel.isHidden = true
            }
            else if textField === phoneField
            {
                phoneErrorLabel.isHidden = true
            }
            else if textField === emailField
            {
                emailErrorLabel.isHidden = true
            }
            else if textField === passwordField
            {
                passwordErrorLabel.isHidden = true
            }
            else
            {
                confirmPasswordErrorLabel.isHidden = true
            }
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField === nameField
        {
            var name = textField.text ?? ""
            name.trim()
            if !name.isEmpty
            {
                if !InputValidator.validateName(name)
                {
                    textField.isInvalid = true
                    nameErrorLabel.text = "Entered Name is Invalid !"
                    nameErrorLabel.isHidden = false
                }
                else
                {
                    textField.isInvalid = false
                    nameErrorLabel.isHidden = true
                }
            }
            else
            {
                textField.isInvalid = false
                nameErrorLabel.isHidden = true
            }
        }
        else if textField === phoneField
        {
            var phone = textField.text ?? ""
            phone.trim()
            if !phone.isEmpty
            {
                if !InputValidator.validatePhone(phone)
                {
                    textField.isInvalid = true
                    phoneErrorLabel.text = "Entered Phone Number is Invalid !"
                    phoneErrorLabel.isHidden = false
                }
                else
                {
                    textField.isInvalid = false
                    phoneErrorLabel.isHidden = true
                }
            }
            else
            {
                textField.isInvalid = false
                phoneErrorLabel.isHidden = true
            }
        }
        else if textField === emailField
        {
            var email = textField.text ?? ""
            email.trim()
            if !email.isEmpty
            {
                if !InputValidator.validateEmail(email)
                {
                    textField.isInvalid = true
                    emailErrorLabel.text = "Entered Email Address is Invalid !"
                    emailErrorLabel.isHidden = false
                }
                else
                {
                    textField.isInvalid = false
                    emailErrorLabel.isHidden = true
                }
            }
            else
            {
                textField.isInvalid = false
                emailErrorLabel.isHidden = true
            }
        }
        else if textField === passwordField
        {
            var password = textField.text ?? ""
            password.trim()
            if !password.isEmpty
            {
                if !InputValidator.validatePassword(password)
                {
                    textField.isInvalid = true
                    passwordErrorLabel.text = "Password must contain at least one uppercase, number, and symbol characters and should have a minimum length of 8"
                    passwordErrorLabel.isHidden = false
                }
                else
                {
                    textField.isInvalid = false
                    passwordErrorLabel.isHidden = true
                }
            }
            else
            {
                textField.isInvalid = false
                passwordErrorLabel.isHidden = true
            }
        }
        else
        {
            var cnfmPassword = textField.text ?? ""
            cnfmPassword.trim()
            if !cnfmPassword.isEmpty
            {
                if !InputValidator.validateConfirmPassword(passwordField.text!, cnfmPassword)
                {
                    textField.isInvalid = true
                    confirmPasswordErrorLabel.text = "Passwords in both fields don't match !"
                    confirmPasswordErrorLabel.isHidden = false
                }
                else
                {
                    textField.isInvalid = false
                    confirmPasswordErrorLabel.isHidden = true
                }
            }
            else
            {
                textField.isInvalid = false
                confirmPasswordErrorLabel.isHidden = true
            }
        }
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
        return 7
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 34
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        switch section
        {
        case 0:
            return nameErrorLabel
        case 1:
            return phoneErrorLabel
        case 2:
            return emailErrorLabel
        case 3:
            return passwordErrorLabel
        case 4:
            return confirmPasswordErrorLabel
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as! CustomTableViewCell
        let section = indexPath.section
        if section == 0
        {
            cell.addSubViewToContentView(nameField)
        }
        else if section == 1
        {
            cell.addSubViewToContentView(phoneField)
        }
        else if section == 2
        {
            cell.addSubViewToContentView(emailField)
        }
        else if section == 3
        {
            cell.addSubViewToContentView(passwordField)
        }
        else if section == 4
        {
            cell.addSubViewToContentView(confirmPasswordField)
        }
        else if section == 5
        {
            cell.addSubViewToContentView(signupButton)
        }
        else
        {
            cell.addSubViewToContentView(accountExistsButton)
        }
        return cell
    }
}

// Obj-C Runtime Functions
extension SignupViewController
{
    @objc func onSignupButtonTap(_ sender: UIButton)
    {
        if nameField.text?.isEmpty ?? true
        {
            nameField.isInvalid = true
            nameErrorLabel.text = "Required"
            nameErrorLabel.isHidden = false
        }
        else
        {
            textFieldDidEndEditing(nameField)
        }
        if phoneField.text?.isEmpty ?? true
        {
            phoneField.isInvalid = true
            phoneErrorLabel.text = "Required"
            phoneErrorLabel.isHidden = false
        }
        else
        {
            textFieldDidEndEditing(phoneField)
        }
        if emailField.text?.isEmpty ?? true
        {
            emailField.isInvalid = true
            emailErrorLabel.text = "Required"
            emailErrorLabel.isHidden = false
        }
        else
        {
            textFieldDidEndEditing(emailField)
        }
        if passwordField.text?.isEmpty ?? true
        {
            passwordField.isInvalid = true
            passwordErrorLabel.text = "Required"
            passwordErrorLabel.isHidden = false
        }
        else
        {
            textFieldDidEndEditing(passwordField)
        }
        if confirmPasswordField.text?.isEmpty ?? true
        {
            confirmPasswordField.isInvalid = true
            confirmPasswordErrorLabel.text = "Required"
            confirmPasswordErrorLabel.isHidden = false
        }
        else
        {
            textFieldDidEndEditing(confirmPasswordField)
        }
        if !nameField.isInvalid && !phoneField.isInvalid && !emailField.isInvalid && !passwordField.isInvalid && !confirmPasswordField.isInvalid
        {
            signupButton.configuration?.showsActivityIndicator = true
            var phone = phoneField.text!
            var email = emailField.text!
            phone.trim()
            email.trim()
            if SessionManager.shared.doesUserAlreadyExist(phone: phone, email: email)
            {
                signupButton.configuration?.showsActivityIndicator = false
                delegate?.onSignupFailure()
            }
            else
            {
                newUser = SessionManager.shared.createNewUserWith(name: nameField.text!.trimmedCopy(), phone: phone, email: email, password: passwordField.text!.trimmedCopy())
                signupButton.configuration?.showsActivityIndicator = false
                delegate?.onSuccessfulSignup()
            }
        }
    }
    
    @objc func onExistingAccountButtonTap(_ sender: UIButton)
    {
        delegate?.onAccountExistsButtonTap()
    }
    
    @objc func onCustomReturnButtonTap(_ sender: UIBarButtonItem)
    {
        if phoneField.isFirstResponder
        {
            emailField.becomeFirstResponder()
        }
        print("Custom Return Button Tapped")
    }
}
extension SignupViewController
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
