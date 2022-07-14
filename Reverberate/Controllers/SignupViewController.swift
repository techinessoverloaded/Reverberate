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
        nField.keyboardType = .namePhonePad
        nField.returnKeyType = .next
        nField.autocapitalizationType = .words
        nField.autocorrectionType = .no
        nField.textContentType = .name
        nField.borderStyle = .roundedRect
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
        pField.keyboardType = .phonePad
        pField.returnKeyType = .next
        pField.autocapitalizationType = .none
        pField.textContentType = .telephoneNumber
        pField.borderStyle = .roundedRect
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
        eField.keyboardType = .emailAddress
        eField.returnKeyType = .next
        eField.autocapitalizationType = .none
        eField.textContentType = .emailAddress
        eField.borderStyle = .roundedRect
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
        passField.keyboardType = .default
        passField.textContentType = .oneTimeCode
        passField.returnKeyType = .next
        passField.autocapitalizationType = .none
        passField.borderStyle = .roundedRect
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
        pass2Field.keyboardType = .default
        pass2Field.textContentType = .oneTimeCode
        pass2Field.returnKeyType = .done
        pass2Field.autocapitalizationType = .none
        pass2Field.borderStyle = .roundedRect
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
        let nErrorLabel = UILabel(useAutoLayout: true)
        nErrorLabel.textColor = .systemRed
        nErrorLabel.font = .preferredFont(forTextStyle: .footnote)
        nErrorLabel.text = "Required"
        nErrorLabel.textAlignment = .right
        return nErrorLabel
    }()
    
    private let phoneErrorLabel: UILabel = {
        let pErrorLabel = UILabel(useAutoLayout: true)
        pErrorLabel.textColor = .systemRed
        pErrorLabel.font = .preferredFont(forTextStyle: .footnote)
        pErrorLabel.text = "Required"
        pErrorLabel.textAlignment = .right
        return pErrorLabel
    }()
    
    private let emailErrorLabel: UILabel = {
        let eErrorLabel = UILabel(useAutoLayout: true)
        eErrorLabel.textColor = .systemRed
        eErrorLabel.font = .preferredFont(forTextStyle: .footnote)
        eErrorLabel.text = "Required"
        eErrorLabel.textAlignment = .right
        return eErrorLabel
    }()
    
    private let passwordErrorLabel: UILabel = {
        let passErrorLabel = UILabel(useAutoLayout: true)
        passErrorLabel.textColor = .systemRed
        passErrorLabel.font = .preferredFont(forTextStyle: .footnote)
        passErrorLabel.text = "Required"
        passErrorLabel.textAlignment = .right
        passErrorLabel.lineBreakMode = .byWordWrapping
        passErrorLabel.numberOfLines = 2
        return passErrorLabel
    }()
    
    private let confirmPasswordErrorLabel: UILabel = {
        let cpErrorLabel = UILabel(useAutoLayout: true)
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
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private let contextSaveAction = (UIApplication.shared.delegate as! AppDelegate).saveContext
    
    private var newUser: User?
    
    private var languageSelectionController: LanguageSelectionCollectionViewController!
    
    override func loadView()
    {
        super.loadView()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
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
        textField.layer.borderWidth = 2
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField === nameField
        {
            var name = textField.text ?? ""
            name.trim()
            if name.isEmpty
            {
                textField.isInvalid = true
                nameErrorLabel.text = "Required"
                nameErrorLabel.isHidden = false
            }
            else if !InputValidator.validateName(name)
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
        else if textField === phoneField
        {
            var phone = textField.text ?? ""
            phone.trim()
            if phone.isEmpty
            {
                textField.isInvalid = true
                phoneErrorLabel.text = "Required"
                phoneErrorLabel.isHidden = false
            }
            else if !InputValidator.validatePhone(phone)
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
        else if textField === emailField
        {
            var email = textField.text ?? ""
            email.trim()
            if email.isEmpty
            {
                textField.isInvalid = true
                emailErrorLabel.text = "Required"
                emailErrorLabel.isHidden = false
            }
            else if !InputValidator.validateEmail(email)
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
        else if textField === passwordField
        {
            var password = textField.text ?? ""
            password.trim()
            if password.isEmpty
            {
                textField.isInvalid = true
                passwordErrorLabel.text = "Required"
                passwordErrorLabel.isHidden = false
            }
            else if !InputValidator.validatePassword(password)
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
            var cnfmPassword = textField.text ?? ""
            cnfmPassword.trim()
            if cnfmPassword.isEmpty
            {
                textField.isInvalid = true
                confirmPasswordErrorLabel.text = "Required"
                confirmPasswordErrorLabel.isHidden = false
            }
            else if !InputValidator.validateConfirmPassword(passwordField.text!, cnfmPassword)
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
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 4
        {
            return 34
        }
        return tableView.estimatedSectionFooterHeight
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        switch section
        {
        case 1:
            return nameErrorLabel
        case 2:
            return phoneErrorLabel
        case 3:
            return emailErrorLabel
        case 4:
            return passwordErrorLabel
        case 5:
            return confirmPasswordErrorLabel
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as! CustomTableViewCell
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

// Core Data Functions
extension SignupViewController
{
    func doesUserAlreadyExist(phone: String, email: String) -> Bool
    {
        var allUsers: [User]!
        do
        {
            allUsers = try context.fetch(User.fetchRequest())
            print(allUsers ?? "nil")
        }
        catch
        {
            print("An error occurred while fetching users \(error)!")
            return false
        }
        return !allUsers.allSatisfy {
            $0.email != email && $0.phone != phone
        }
    }
    
}

// Obj-C Runtime Functions
extension SignupViewController
{
    @objc func onSignupButtonTap(_ sender: UIButton)
    {
        textFieldDidEndEditing(nameField)
        textFieldDidEndEditing(phoneField)
        textFieldDidEndEditing(emailField)
        textFieldDidEndEditing(passwordField)
        textFieldDidEndEditing(confirmPasswordField)
        if !nameField.isInvalid && !phoneField.isInvalid && !emailField.isInvalid && !passwordField.isInvalid && !confirmPasswordField.isInvalid
        {
            signupButton.configuration?.showsActivityIndicator = true
            var phone = phoneField.text!
            var email = emailField.text!
            phone.trim()
            email.trim()
            if doesUserAlreadyExist(phone: phone, email: email)
            {
                signupButton.configuration?.showsActivityIndicator = false
                let alert = UIAlertController(title: "Existing Account", message: "A User Account with the given Phone Number and/or Email Address exists already ! You can proceed to Login !", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Proceed to Login", style: .default) { _ in
                    (UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate).changeRootViewController(LoginViewController(style: .insetGrouped))
                })
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel){ _ in
                    (UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate).changeRootViewController(SignupViewController(style: .insetGrouped), animationOption: 1)
                })
                activateContentBlurViewConstraints()
                alert.modalPresentationStyle = .popover
                self.present(alert, animated: true)
            }
            else
            {
                newUser = User(context: self.context)
                // Generate Universally Unique ID using UUID
                newUser!.id = UUID().uuidString
                newUser!.name = nameField.text!.trimmedCopy()
                newUser!.phone = phoneField.text!.trimmedCopy()
                newUser!.email = emailField.text!.trimmedCopy()
                newUser!.password = passwordField.text!.trimmedCopy()
                newUser!.profilePicture = UIImage(systemName: "person.fill")!.withTintColor(.systemGray).jpegData(compressionQuality: 1)!
                print("Signing up...")
                self.contextSaveAction()
                UserDefaults.standard.set(newUser!.id, forKey: GlobalConstants.currentUserId)
                UserDefaults.standard.set(false, forKey: GlobalConstants.isFirstTime)
                signupButton.configuration?.showsActivityIndicator = false
                print("User Signed up successfully with id: \(String(describing: newUser!.id))")
               languageSelectionController = LanguageSelectionCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
                languageSelectionController.delegate = self
                languageSelectionController.rightBarButtonCustomTitle = "Next"
                activateContentBlurViewConstraints()
                let navController = UINavigationController(rootViewController: languageSelectionController)
                navController.modalPresentationStyle = .pageSheet
                navController.isModalInPresentation = true
                self.present(navController, animated: true)
            }
        }
    }
    
    @objc func onExistingAccountButtonTap(_ sender: UIButton)
    {
        print("Moving on to Login Screen...")
        (UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate).changeRootViewController(LoginViewController(style: .insetGrouped))
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

extension SignupViewController: LanguageSelectionDelegate
{
    func onLanguageSelection(selectedLanguages: [Int16])
    {
        newUser!.preferredLanguages = selectedLanguages
        contextSaveAction()
        let genreSelectionController = GenreSelectionCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        genreSelectionController.delegate = self
        genreSelectionController.leftBarButtonCustomTitle = "Previous"
        genreSelectionController.rightBarButtonType = .done
        let navController = UINavigationController(rootViewController: genreSelectionController)
        navController.modalPresentationStyle = .pageSheet
        navController.isModalInPresentation = true
        languageSelectionController.present(navController, animated: true)
    }
}

extension SignupViewController: GenreSelectionDelegate
{
    func onGenreSelection(selectedGenres: [Int16])
    {
        newUser!.preferredGenres = selectedGenres
        contextSaveAction()
        print(newUser!)
        (UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate).changeRootViewController(MainViewController())
    }
}
