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
        epField.layer.borderColor = UIColor(named: GlobalConstants.techinessColor)!.withAlphaComponent(0.7).cgColor
        //Changeable Property
        epField.placeholder = "Email Address"
        epField.clearButtonMode = .whileEditing
        //Changeable Property
        epField.keyboardType = .emailAddress
        epField.returnKeyType = .next
        epField.autocapitalizationType = .none
        //Changeable Property
        epField.textContentType = .emailAddress
        epField.borderStyle = .roundedRect
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
        passField.keyboardType = .default
        passField.returnKeyType = .done
        passField.textContentType = .oneTimeCode
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
        let epErrorLabel = UILabel(useAutoLayout: true)
        epErrorLabel.textColor = .systemRed
        epErrorLabel.font = .preferredFont(forTextStyle: .footnote)
        epErrorLabel.text = "Required"
        epErrorLabel.textAlignment = .right
        return epErrorLabel
    }()
    
    private let passwordErrorLabel: UILabel = {
        let passErrorLabel = UILabel(useAutoLayout: true)
        passErrorLabel.textColor = .systemRed
        passErrorLabel.font = .preferredFont(forTextStyle: .footnote)
        passErrorLabel.text = "Required"
        passErrorLabel.textAlignment = .right
        return passErrorLabel
    }()
    
    private let contentBlurView: CustomVisualEffectView =
    {
        let cbView = CustomVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterial), intensity: 0.5)
        cbView.enableAutoLayout()
        return cbView
    }()
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private let contextSaveAction = (UIApplication.shared.delegate as! AppDelegate).saveContext
    
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
        emailOrPhoneSelector.selectedSegmentTintColor = UIColor(named: GlobalConstants.techinessColor)
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        emailOrPhoneSelector.setTitleTextAttributes(titleTextAttributes, for: .selected)
        emailCumPhoneField.delegate = self
        passwordField.delegate = self
        emailCumPhoneField.becomeFirstResponder()
        emailOrPhoneSelector.addTarget(self, action: #selector(onEmailPhoneSelectionChange(_:)), for: .valueChanged)
        loginButton.addTarget(self, action: #selector(onLoginButtonTap(_:)), for: .touchUpInside)
        noAccountButton.addTarget(self, action: #selector(onNoAccountButtonTap(_:)), for: .touchUpInside)
        emailCumPhoneErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        print("Login View Controller")
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

extension LoginViewController: UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        textField.layer.borderWidth = 2
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField === emailCumPhoneField
        {
            if emailOrPhoneSelector.selectedSegmentIndex == 0
            {
                let email = textField.text ?? ""
                if email.isEmpty
                {
                    textField.isInvalid = true
                    emailCumPhoneErrorLabel.text = "Required"
                    emailCumPhoneErrorLabel.isHidden = false
                }
                else if !InputValidator.validateEmail(email)
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
                let phone = textField.text ?? ""
                if phone.isEmpty
                {
                    textField.isInvalid = true
                    emailCumPhoneErrorLabel.text = "Required"
                    emailCumPhoneErrorLabel.isHidden = false
                }
                else if !InputValidator.validatePhone(phone)
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
        }
        else
        {
            let password = textField.text ?? ""
            if password.isEmpty
            {
                textField.isInvalid = true
                passwordErrorLabel.isHidden = false
            }
            else
            {
                textField.isInvalid = false
                passwordErrorLabel.isHidden = true
            }
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
        6
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        1
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        switch section
        {
        case 2:
            return emailCumPhoneErrorLabel
        case 3:
            return passwordErrorLabel
        default:
            return nil
        }
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
        emailCumPhoneField.becomeFirstResponder()
    }
    
    @objc func onLoginButtonTap(_ sender: UIButton)
    {
        textFieldDidEndEditing(emailCumPhoneField)
        textFieldDidEndEditing(passwordField)
        if !emailCumPhoneField.isInvalid && !passwordField.isInvalid
        {
            var user: User?
            if emailOrPhoneSelector.selectedSegmentIndex == 0
            {
                let email = emailCumPhoneField.text!
                let password = passwordField.text!
                user = validateUser(email: email, password: password)
            }
            else
            {
                let phone = emailCumPhoneField.text!
                let password = passwordField.text!
                user = validateUser(phone: phone, password: password)
            }
            if user != nil
            {
                loginButton.configuration?.showsActivityIndicator = true
                print("Logging in...")
                UserDefaults.standard.set(user!.id, forKey: GlobalConstants.currentUserId)
                loginButton.configuration?.showsActivityIndicator = false
                (UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate).changeRootViewController(MainViewController())
            }
            else
            {
                let alert = UIAlertController(title: "Invalid Credentials", message: "No User Accounts were found for the entered Credentials ! Check your credentials or try creating a new account maybe !", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Proceed to Signup", style: .default) { _ in
                        (UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate).changeRootViewController(SignupViewController(style: .insetGrouped))
                })
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
                        (UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate).changeRootViewController(LoginViewController(style: .insetGrouped), animationOption: 1)
                })
                activateContentBlurViewConstraints()
                alert.modalPresentationStyle = .popover
                self.present(alert, animated: true)
            }
        }
    }
    
    @objc func onNoAccountButtonTap(_ sender: UIButton)
    {
        (UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate).changeRootViewController(SignupViewController(style: .insetGrouped))
        print("Moving on to Signup Screen...")
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

// Core Data Functions
extension LoginViewController
{
    func validateUser(email: String, password: String) -> User?
    {
        var allUsers: [User]!
        do
        {
            allUsers = try context.fetch(User.fetchRequest())
            print(allUsers ?? "No users")
        }
        catch
        {
            print("Error in retrieving saved Users !")
            return nil
        }
        let filteredUsers = allUsers.filter {
            $0.email == email && $0.password == password
        }
        if filteredUsers.isEmpty
        {
            return nil
        }
        return filteredUsers[0]
    }
    
    func validateUser(phone: String, password: String) -> User?
    {
        var allUsers: [User]!
        do
        {
            allUsers = try context.fetch(User.fetchRequest())
            print(allUsers ?? "No users")
        }
        catch
        {
            print("Error in retrieving saved Users !")
            return nil
        }
        let filteredUsers = allUsers.filter {
            $0.phone == phone && $0.password == password
        }
        if filteredUsers.isEmpty
        {
            return nil
        }
        return filteredUsers[0]
    }
}
