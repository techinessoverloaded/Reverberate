//
//  ProfileViewController.swift
//  Reverberate
//
//  Created by arun-13930 on 07/07/22.
//

import UIKit
import CoreData

class ProfileViewController: UITableViewController
{
    private lazy var profilePictureView: UIImageView = {
        let pView = UIImageView(useAutoLayout: true)
        pView.layer.borderWidth = 4
        pView.layer.borderColor = UIColor.systemBlue.cgColor
        pView.backgroundColor = .clear
        pView.contentMode = .scaleAspectFill
        pView.clipsToBounds = true
        return pView
    }()
    
    private lazy var nameLabel: UILabel = {
        let nLabel = UILabel(useAutoLayout: true)
        nLabel.textColor = .label
        nLabel.font = .systemFont(ofSize: 28, weight: .bold)
        nLabel.textAlignment = .center
        return nLabel
    }()
    
    private lazy var emailLabel: UILabel = {
        let eLabel = UILabel(useAutoLayout: false)
        eLabel.textAlignment = .left
        eLabel.font = .preferredFont(forTextStyle: .body)
        eLabel.textColor = .label
        return eLabel
    }()
    
    private lazy var phoneLabel: UILabel = {
        let pLabel = UILabel(useAutoLayout: false)
        pLabel.textAlignment = .left
        pLabel.font = .preferredFont(forTextStyle: .body)
        pLabel.textColor = .label
        return pLabel
    }()
    
    private let userInfoTitleLabel: UILabel = {
        let uiLabel = UILabel()
        uiLabel.textAlignment = .left
        uiLabel.font = .preferredFont(forTextStyle: .footnote)
        uiLabel.textColor = .secondaryLabel
        uiLabel.text = " USER INFORMATION"
        return uiLabel
    }()
    
    private let userPrefTitleLabel: UILabel = {
        let upLabel = UILabel()
        upLabel.textAlignment = .left
        upLabel.font = .preferredFont(forTextStyle: .footnote)
        upLabel.textColor = .secondaryLabel
        upLabel.text = " USER PREFERENCES"
        return upLabel
    }()
    
    private var editProfileButton: UIBarButtonItem!
    
    private lazy var logoutButton: UIButton = {
        let lButton = UIButton(type: .roundedRect)
        lButton.setTitle("Logout", for: .normal)
        lButton.backgroundColor = .systemRed.withAlphaComponent(0.3)
        lButton.tintColor = .systemRed
        lButton.titleLabel?.font = .preferredFont(forTextStyle: .body)
        lButton.layer.cornerRadius = 10
        lButton.layer.cornerCurve = .circular
        return lButton
    }()
    
    private let themeChooser: UISegmentedControl = {
        let tChooser = UISegmentedControl(items: ["System", "Light", "Dark"])
        tChooser.selectedSegmentIndex = UserDefaults.standard.integer(forKey: GlobalConstants.themePreference)
        tChooser.selectedSegmentTintColor = .init(named: GlobalConstants.techinessColor)
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        tChooser.setTitleTextAttributes(titleTextAttributes, for: .selected)
        return tChooser
    }()
    
    private var languageSelectionVC: LanguageSelectionCollectionViewController!
    
    private var genreSelectionVC: GenreSelectionCollectionViewController!
    
    private var loginController: LoginViewController!
    
    private var signupController: SignupViewController!
    
    private var user: User
    {
        return GlobalVariables.shared.currentUser!
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        configureAccordingToSession()
        view.backgroundColor = .systemGroupedBackground
        tableView.rowHeight = 44
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
    }
    
    func configureAccordingToSession()
    {
        if SessionManager.shared.isUserLoggedIn
        {
            navigationController?.navigationBar.prefersLargeTitles = false
            navigationItem.largeTitleDisplayMode = .never
            tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
            tableView.register(LabeledInfoTableViewCell.self, forCellReuseIdentifier: LabeledInfoTableViewCell.identifier)
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            tableView.allowsSelection = true
            editProfileButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(onEditButtonTap(_:)))
            navigationItem.rightBarButtonItem = editProfileButton
            logoutButton.addTarget(self, action: #selector(onLogoutButtonTap(_:)), for: .touchUpInside)
            themeChooser.addTarget(self, action: #selector(onThemeSelection(_:)), for: .valueChanged)
            NotificationCenter.default.addObserver(self, selector: #selector(onContextSaveAction(notification:)), name: NSManagedObjectContext.didSaveObjectsNotification, object: GlobalConstants.context)
        }
        else
        {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .always
            navigationItem.rightBarButtonItem = nil
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            tableView.allowsSelection = true
            themeChooser.addTarget(self, action: #selector(onThemeSelection(_:)), for: .valueChanged)
        }
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        if SessionManager.shared.isUserLoggedIn
        {
            profilePictureView.layer.cornerRadius = profilePictureView.bounds.height / 2
        }
    }
    
    deinit
    {
        if SessionManager.shared.isUserLoggedIn
        {
            NotificationCenter.default.removeObserver(self, name: NSManagedObjectContext.didSaveObjectsNotification, object: GlobalConstants.context)
        }
    }
    
    func setUserDetails()
    {
        nameLabel.text = user.name
        let indexPathOfVisibleRows = tableView.indexPathsForVisibleRows!
        let emailIndexPath = IndexPath(item: 0, section: 2)
        let phoneIndexPath = IndexPath(item: 1, section: 2)
        if indexPathOfVisibleRows.contains(emailIndexPath)
        {
            let emailCell = tableView.cellForRow(at: emailIndexPath)!
            var emailConfig = emailCell.contentConfiguration as! UIListContentConfiguration
            emailConfig.secondaryText = user.email
            emailCell.contentConfiguration = emailConfig
        }
        if indexPathOfVisibleRows.contains(phoneIndexPath)
        {
            let phoneCell = tableView.cellForRow(at: phoneIndexPath)!
            var phoneConfig = phoneCell.contentConfiguration as! UIListContentConfiguration
            phoneConfig.secondaryText = user.phone
            phoneCell.contentConfiguration = phoneConfig
        }
        let userProfilePicture = UIImage(data: user.profilePicture!)
        profilePictureView.image = userProfilePicture
    }
    
    func showLoginViewController()
    {
        loginController = LoginViewController(style: .insetGrouped)
        loginController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(onSignUpLoginCancel(_:)))
        loginController.delegate = self
        let navController = UINavigationController(rootViewController: loginController)
        navController.modalPresentationStyle = .pageSheet
        navController.isModalInPresentation = false
        self.present(navController, animated: true)
    }
    
    func showSignupViewController()
    {
        signupController = SignupViewController(style: .insetGrouped)
        signupController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(onSignUpLoginCancel(_:)))
        signupController.delegate = self
        let navController = UINavigationController(rootViewController: signupController)
        navController.modalPresentationStyle = .pageSheet
        navController.isModalInPresentation = false
        self.present(navController, animated: true)
    }
}

// TableView Delegate and Datasource
extension ProfileViewController
{
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        if SessionManager.shared.isUserLoggedIn
        {
            return 5
        }
        else
        {
            return 2
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if SessionManager.shared.isUserLoggedIn
        {
            if section == 0
            {
                return 1
            }
            else if section == 1
            {
                return 1
            }
            else if section == 2
            {
                return 2
            }
            else if section == 3
            {
                return 3
            }
            else
            {
                return 1
            }
        }
        else
        {
           if section == 0
            {
               return 1
           }
            else
            {
                return 3
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if SessionManager.shared.isUserLoggedIn
        {
            if indexPath.section == 0
            {
                return 130
            }
            else
            {
                return tableView.rowHeight
            }
        }
        else
        {
            if indexPath.section == 0
            {
                return 100
            }
            else
            {
                return tableView.rowHeight
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if SessionManager.shared.isUserLoggedIn
        {
            switch section
            {
            case 2:
                return userInfoTitleLabel
            case 3:
                return userPrefTitleLabel
            default:
                return nil
            }
        }
        else
        {
            switch section
            {
            case 0:
                return userInfoTitleLabel
            case 1:
                return userPrefTitleLabel
            default:
                return nil
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if SessionManager.shared.isUserLoggedIn
        {
            if section == 2 || section == 3
            {
                return 30
            }
            else
            {
                return CGFloat.zero
            }
        }
        else
        {
            return 50
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let section = indexPath.section
        let item = indexPath.item
        if SessionManager.shared.isUserLoggedIn
        {
            if section == 0
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as! CustomTableViewCell
                cell.selectionStyle = .none
                //Hide Separator
                cell.separatorInset = .init(top: 0, left: cell.contentView.bounds.width, bottom: 0, right: 0)
                profilePictureView.image = UIImage(data: user.profilePicture!)!
                cell.addSubViewToContentView(profilePictureView, useAutoLayout: true)
                return cell
            }
            else if section == 1
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as! CustomTableViewCell
                cell.selectionStyle = .none
                //Hide Separator
                cell.separatorInset = .init(top: 0, left: cell.contentView.bounds.width, bottom: 0, right: 0)
                nameLabel.text = user.name!
                cell.addSubViewToContentView(nameLabel, useAutoLayout: true)
                return cell
            }
            else if section == 2
            {
                //let cell = tableView.dequeueReusableCell(withIdentifier: LabeledInfoTableViewCell.identifier, for: indexPath) as! LabeledInfoTableViewCell
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                cell.selectionStyle = .none
                //Show separator
                cell.separatorInset = .zero
                var config = UIListContentConfiguration.valueCell()//cell.defaultContentConfiguration()
                if item == 0
                {
                    config.text = "Email Address"
                    config.secondaryText = user.email!
                    config.textProperties.color = .systemGray
                    config.textProperties.adjustsFontForContentSizeCategory = true
                    config.secondaryTextProperties.color = .label
                    config.secondaryTextProperties.adjustsFontForContentSizeCategory = true
                    config.prefersSideBySideTextAndSecondaryText = true
                    cell.contentConfiguration = config
                    //cell.configureCell(title: "Email Address", infoView: emailLabel)
                    return cell
                }
                else
                {
                    config.text = "Phone Number"
                    config.secondaryText = user.phone!
                    config.textProperties.color = .systemGray
                    config.textProperties.adjustsFontForContentSizeCategory = true
                    config.secondaryTextProperties.color = .label
                    config.secondaryTextProperties.adjustsFontForContentSizeCategory = true
                    config.prefersSideBySideTextAndSecondaryText = true
                    cell.contentConfiguration = config
                    //cell.configureCell(title: "Phone Number", infoView: phoneLabel)
                    return cell
                }
            }
            else if section == 3
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                //Show separator
                cell.separatorInset = .zero
                var config = cell.defaultContentConfiguration()
                if item == 0
                {
                    config.text = "Languages"
                    cell.selectionStyle = .default
                    cell.accessoryType = .disclosureIndicator
                }
                else if item == 1
                {
                    config.text = "Music Genres"
                    cell.selectionStyle = .default
                    cell.accessoryType = .disclosureIndicator
                }
                else
                {
                    config.text = "Theme"
                    cell.selectionStyle = .none
                    cell.accessoryType = .none
                    cell.accessoryView = themeChooser
                }
                cell.contentConfiguration = config
                return cell
            }
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as! CustomTableViewCell
                cell.addSubViewToContentView(logoutButton, useAutoLayout: false)
                cell.selectionStyle = .none
                // Hide Separator
                cell.separatorInset = .init(top: 0, left: cell.contentView.bounds.width, bottom: 0, right: 0)
                return cell
            }
        }
        else
        {
            if section == 0
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                //Hide Separator
                var config = cell.defaultContentConfiguration()
                config.image = UIImage(systemName: "person.crop.circle.fill")!
                config.imageProperties.tintColor = .systemGray
                config.imageProperties.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: cell.bounds.height * 0.5)
                config.imageToTextPadding = 25
                config.textToSecondaryTextVerticalPadding = 10
                config.text = "Login to get a better experience"
                config.textProperties.color = .systemBlue
                config.secondaryText = "Preserve favourite playlists and do more."
                config.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 20)
                cell.contentConfiguration = config
                cell.separatorInset = .init(top: 0, left: cell.contentView.bounds.width, bottom: 0, right: 0)
                return cell
            }
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                //Show separator
                cell.separatorInset = .zero
                var config = cell.defaultContentConfiguration()
                if item == 0
                {
                    config.text = "Languages"
                    cell.selectionStyle = .default
                    cell.accessoryType = .disclosureIndicator
                }
                else if item == 1
                {
                    config.text = "Music Genres"
                    cell.selectionStyle = .default
                    cell.accessoryType = .disclosureIndicator
                }
                else
                {
                    config.text = "Theme"
                    cell.selectionStyle = .none
                    cell.accessoryType = .none
                    cell.accessoryView = themeChooser
                }
                cell.contentConfiguration = config
                return cell
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let section = indexPath.section
        let item = indexPath.item
        if SessionManager.shared.isUserLoggedIn
        {
            if section == 3
            {
                if item == 0
                {
                    tableView.deselectRow(at: indexPath, animated: true)
                    languageSelectionVC = LanguageSelectionCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
                    languageSelectionVC.delegate = self
                    languageSelectionVC.leftBarButtonType = .cancel
                    languageSelectionVC.rightBarButtonType = .done
                    languageSelectionVC.preSelectedLanguages = user.preferredLanguages!
                    languageSelectionVC.areCellsPreselected = true
                    let navController = UINavigationController(rootViewController: languageSelectionVC)
                    navController.modalPresentationStyle = .pageSheet
                    navController.isModalInPresentation = false
                    self.present(navController, animated: true)
                }
                else if item == 1
                {
                    tableView.deselectRow(at: indexPath, animated: true)
                    genreSelectionVC = GenreSelectionCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
                    genreSelectionVC.delegate = self
                    genreSelectionVC.leftBarButtonType = .cancel
                    genreSelectionVC.rightBarButtonType = .done
                    genreSelectionVC.preSelectedGenres = user.preferredGenres!
                    genreSelectionVC.areCellsPreselected = true
                    let navController = UINavigationController(rootViewController: genreSelectionVC)
                    navController.modalPresentationStyle = .pageSheet
                    navController.isModalInPresentation = false
                    self.present(navController, animated: true)
                }
            }
        }
        else
        {
            if section == 0
            {
                tableView.deselectRow(at: indexPath, animated: true)
                showLoginViewController()
            }
            else
            {
                if item == 0
                {
                    tableView.deselectRow(at: indexPath, animated: true)
                    languageSelectionVC = LanguageSelectionCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
                    languageSelectionVC.delegate = self
                    languageSelectionVC.leftBarButtonType = .cancel
                    languageSelectionVC.rightBarButtonType = .done
                    languageSelectionVC.preSelectedLanguages = (UserDefaults.standard.object(forKey: GlobalConstants.preferredLanguages) as! [Int16])
                    languageSelectionVC.areCellsPreselected = true
                    let navController = UINavigationController(rootViewController: languageSelectionVC)
                    navController.modalPresentationStyle = .pageSheet
                    navController.isModalInPresentation = false
                    self.present(navController, animated: true)
                }
                else if item == 1
                {
                    tableView.deselectRow(at: indexPath, animated: true)
                    genreSelectionVC = GenreSelectionCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
                    genreSelectionVC.delegate = self
                    genreSelectionVC.leftBarButtonType = .cancel
                    genreSelectionVC.rightBarButtonType = .done
                    genreSelectionVC.preSelectedGenres = (UserDefaults.standard.object(forKey: GlobalConstants.preferredGenres) as! [Int16])
                    genreSelectionVC.areCellsPreselected = true
                    let navController = UINavigationController(rootViewController: genreSelectionVC)
                    navController.modalPresentationStyle = .pageSheet
                    navController.isModalInPresentation = false
                    self.present(navController, animated: true)
                }
            }
        }
    }
}

extension ProfileViewController
{
    @objc func onSignUpLoginCancel(_ sender: UIBarButtonItem)
    {
        if loginController != nil
        {
            loginController.dismiss(animated: true)
            loginController = nil
        }
        if signupController != nil
        {
            signupController.dismiss(animated: true)
            signupController = nil
        }
    }
    
    @objc func onEditButtonTap(_ sender: UIButton)
    {
        print("Edit Profile Tapped")
        let editProfileController = EditProfileViewController(style: .insetGrouped)
        editProfileController.userRef = user
        let modalNavController = UINavigationController(rootViewController: editProfileController)
        modalNavController.modalPresentationStyle = .pageSheet
        modalNavController.isModalInPresentation = false
        self.present(modalNavController, animated: true)
    }
    
    @objc func onLogoutButtonTap(_ sender: UIButton)
    {
        let alert: UIAlertController = UIAlertController(title: "Logout Confirmation", message: "Do you want to logout for sure ?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default) { _ in
            SessionManager.shared.logoutUser()
            DispatchQueue.main.async {
                (UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate).changeRootViewController(InitialViewController(style: .insetGrouped))
            }
        })
        alert.addAction(UIAlertAction(title: "No", style: .destructive))
        self.present(alert, animated: true)
    }
    
    @objc func onThemeSelection(_ sender: UISegmentedControl)
    {
        (UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate).changeTheme(themeOption: sender.selectedSegmentIndex)
    }
    
    @objc func onContextSaveAction(notification: NSNotification)
    {
        setUserDetails()
    }
}

extension ProfileViewController: LanguageSelectionDelegate
{
    func onLanguageSelection(selectedLanguages: [Int16])
    {
        if SessionManager.shared.isUserLoggedIn
        {
            user.preferredLanguages = selectedLanguages
            GlobalConstants.contextSaveAction()
        }
        else
        {
            UserDefaults.standard.set(selectedLanguages, forKey: GlobalConstants.preferredLanguages)
        }
        NotificationCenter.default.post(name: .languageGenreChangeNotification, object: nil)
    }
}

extension ProfileViewController: GenreSelectionDelegate
{
    func onGenreSelection(selectedGenres: [Int16])
    {
        if SessionManager.shared.isUserLoggedIn
        {
            user.preferredGenres = selectedGenres
            GlobalConstants.contextSaveAction()
        }
        else
        {
            UserDefaults.standard.set(selectedGenres, forKey: GlobalConstants.preferredGenres)
        }
        NotificationCenter.default.post(name: .languageGenreChangeNotification, object: nil)
    }
}

extension ProfileViewController: LoginDelegate
{
    func onSuccessfulLogin()
    {
        let newProfileVC = ProfileViewController(style: .insetGrouped)
        newProfileVC.title = "Your Profile"
        GlobalVariables.shared.mainTabController.replaceViewController(index: 3, newViewController: newProfileVC)
        NotificationCenter.default.post(name: .userLoggedInNotification, object: nil)
        loginController.dismiss(animated: true)
    }
    
    func onLoginFailure()
    {
        let alert = UIAlertController(title: "Invalid Credentials", message: "No User Accounts were found for the entered Credentials ! Check your credentials or try creating a new account maybe !", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: .default) { [unowned self] _ in
            self.showLoginViewController()
        })
        alert.addAction(UIAlertAction(title: "Proceed to Signup", style: .default) { [unowned self] _ in
            self.showSignupViewController()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        loginController.dismiss(animated: true)
        loginController = nil
        self.present(alert, animated: true)
    }
    
    func onNoAccountButtonTap()
    {
        loginController.dismiss(animated: true)
        {
            [unowned self] in
            self.showSignupViewController()
        }
        loginController = nil
    }
}

extension ProfileViewController: SignupDelegate
{
    func onSuccessfulSignup()
    {
        let newProfileVC = ProfileViewController(style: .insetGrouped)
            newProfileVC.title = "Your Profile"
        user.preferredLanguages = (UserDefaults.standard.object(forKey: GlobalConstants.preferredLanguages) as! [Int16])
        user.preferredGenres = (UserDefaults.standard.object(forKey: GlobalConstants.preferredGenres) as! [Int16])
        GlobalConstants.contextSaveAction()
        //GlobalVariables.shared.mainTabController.replaceViewController(index: 3, newViewController: newProfileVC)
        configureAccordingToSession()
        tableView.reloadData()
        NotificationCenter.default.post(name: .userLoggedInNotification, object: nil)
        signupController.dismiss(animated: true)
    }
    
    func onSignupFailure()
    {
        let alert = UIAlertController(title: "Existing Account", message: "A User Account with the given Phone Number and/or Email Address exists already ! You can proceed to Login !", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: .default) { [unowned self] _ in
            self.showSignupViewController()
        })
        alert.addAction(UIAlertAction(title: "Proceed to Login", style: .default) { [unowned self] _ in
            self.showLoginViewController()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        signupController.dismiss(animated: true)
        signupController = nil
        self.present(alert, animated: true)
    }
    
    func onAccountExistsButtonTap()
    {
        signupController.dismiss(animated: true)
        { [unowned self] in
            self.showLoginViewController()
        }
        signupController = nil
    }
}
