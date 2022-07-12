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
    private let profilePictureView: UIImageView = {
        let pView = UIImageView(useAutoLayout: true)
        let profilePictureConfiguration = UIImage.SymbolConfiguration(pointSize: 130)
        let defaultProfileImage = UIImage(systemName: "person.circle", withConfiguration: profilePictureConfiguration)
        pView.image = defaultProfileImage
        pView.layer.borderWidth = 0
        pView.layer.borderColor = UIColor.systemGray.cgColor
        pView.backgroundColor = .clear
        pView.tintColor = .systemGray
        pView.contentMode = .scaleAspectFit
        pView.clipsToBounds = true
        return pView
    }()
    
    private let nameLabel: UILabel = {
        let nLabel = UILabel(useAutoLayout: true)
        nLabel.textColor = .label
        nLabel.font = .systemFont(ofSize: 28, weight: .bold)
        nLabel.textAlignment = .center
        return nLabel
    }()
    
    private let emailLabel: UILabel = {
        let eLabel = UILabel(useAutoLayout: true)
        eLabel.textAlignment = .left
        eLabel.font = .preferredFont(forTextStyle: .subheadline)
        eLabel.textColor = .label
        return eLabel
    }()
    
    private let phoneLabel: UILabel = {
        let pLabel = UILabel(useAutoLayout: true)
        pLabel.textAlignment = .left
        pLabel.font = .preferredFont(forTextStyle: .subheadline)
        pLabel.textColor = .label
        return pLabel
    }()
    
    private var editProfileButton: UIBarButtonItem!
    
    private let logoutButton: UIButton = {
        let lButton = UIButton(type: .roundedRect)
        lButton.setTitle("Logout", for: .normal)
        lButton.backgroundColor = UIColor(named: GlobalConstants.techinessColor)
        lButton.tintColor = .white
        lButton.titleLabel?.font = .preferredFont(forTextStyle: .body)
        lButton.layer.cornerRadius = 10
        lButton.layer.cornerCurve = .circular
        //lButton.enableAutoLayout()
        return lButton
    }()
    
    private let themeChooser: UISegmentedControl = {
        let tChooser = UISegmentedControl(items: ["System", "Light", "Dark"])
        tChooser.enableAutoLayout()
        tChooser.selectedSegmentIndex = UserDefaults.standard.integer(forKey: GlobalConstants.themePreference)
        tChooser.selectedSegmentTintColor = .init(named: GlobalConstants.techinessColor)
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        tChooser.setTitleTextAttributes(titleTextAttributes, for: .selected)
        return tChooser
    }()
    
    private var languageSelectionVC: LanguageSelectionCollectionViewController!
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var user: User!
    
    override func loadView()
    {
        super.loadView()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        self.navigationController?.navigationBar.prefersLargeTitles = false
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        tableView.register(LabeledInfoTableViewCell.self, forCellReuseIdentifier: LabeledInfoTableViewCell.identifier)
        tableView.allowsSelection = true
        setUserDetails()
        editProfileButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(onEditButtonTap(_:)))
        navigationItem.rightBarButtonItem = editProfileButton
        logoutButton.addTarget(self, action: #selector(onLogoutButtonTap(_:)), for: .touchUpInside)
        themeChooser.addTarget(self, action: #selector(onThemeSelection(_:)), for: .valueChanged)
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        profilePictureView.layer.cornerRadius = profilePictureView.bounds.height / 2
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(onContextSaveAction(notification:)), name: NSManagedObjectContext.didSaveObjectsNotification, object: context)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        NotificationCenter.default.removeObserver(self, name: NSManagedObjectContext.didSaveObjectsNotification, object: context)
        super.viewWillDisappear(animated)
    }
    
    func setUserDetails()
    {
        user = try! context.fetch(User.fetchRequest()).first {
            $0.id == UserDefaults.standard.string(forKey: GlobalConstants.currentUserId)
        }
        nameLabel.text = user.name
        emailLabel.text = user.email
        phoneLabel.text = user.phone
    }
}

// TableView Delegate and Datasource
extension ProfileViewController
{
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0
        {
            return 2
        }
        else if section == 1
        {
            return 2
        }
        else if section == 2
        {
            return 3
        }
        else
        {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0 && indexPath.item == 0
        {
            return 150
        }
        else
        {
            return tableView.estimatedRowHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        if section == 1
        {
            return "User Information"
        }
        else if section == 2
        {
            return "User Preferences"
        }
        else
        {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let section = indexPath.section
        let item = indexPath.item
        if section == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as! CustomTableViewCell
            cell.selectionStyle = .none
            //Hide Separator
            cell.separatorInset = .init(top: 0, left: cell.contentView.bounds.width, bottom: 0, right: 0)
            switch item
            {
            case 0:
                cell.addSubViewToContentView(profilePictureView, useAutoLayout: true)
                return cell
            case 1:
                cell.addSubViewToContentView(nameLabel, useAutoLayout: true)
                return cell
            default:
                return cell
            }
        }
        else if section == 1
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: LabeledInfoTableViewCell.identifier, for: indexPath) as! LabeledInfoTableViewCell
            cell.selectionStyle = .none
            //Show separator
            cell.separatorInset = .zero
            switch item
            {
            case 0:
                cell.configureCell(title: "Email Address", infoView: emailLabel)
                return cell
            case 1:
                cell.configureCell(title: "Phone Number", infoView: phoneLabel)
                return cell
            default:
                return cell
            }
        }
        else if section == 2
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: LabeledInfoTableViewCell.identifier, for: indexPath) as! LabeledInfoTableViewCell
            //Show separator
            cell.separatorInset = .zero
            if item == 0
            {
                cell.configureCell(title: "Languages", infoView: nil, useBrightLabelColor: true)
                cell.selectionStyle = .default
                cell.accessoryType = .disclosureIndicator
            }
            else if item == 1
            {
                cell.configureCell(title: "Music Genres", infoView: nil, useBrightLabelColor: true)
                cell.selectionStyle = .default
                cell.accessoryType = .disclosureIndicator
            }
            else
            {
                cell.configureCell(title: "Theme", infoView: themeChooser, arrangeInfoViewToRightEnd: true, useBrightLabelColor: true)
                cell.selectionStyle = .none
            }
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let section = indexPath.section
        let item = indexPath.item
        if section == 2
        {
            if item == 0
            {
                tableView.deselectRow(at: indexPath, animated: true)
                languageSelectionVC = LanguageSelectionCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
                languageSelectionVC.delegate = self
                self.present(languageSelectionVC, animated: true)
            }
            else if item == 1
            {
                tableView.deselectRow(at: indexPath, animated: true)
                let genreSelectionVC = GenreSelectionCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
                genreSelectionVC.delegate = self
                self.present(genreSelectionVC, animated: true)
            }
        }
    }
}

extension ProfileViewController
{
    @objc func onEditButtonTap(_ sender: UIButton)
    {
        print("Edit Profile Tapped")
        let editProfileController = EditProfileViewController(style: .insetGrouped)
        editProfileController.userRef = user
        let modalNavController = UINavigationController(rootViewController: editProfileController)
        modalNavController.modalPresentationStyle = .formSheet
        modalNavController.isModalInPresentation = true
        self.present(modalNavController, animated: true)
    }
    
    @objc func onLogoutButtonTap(_ sender: UIButton)
    {
        let alert: UIAlertController = UIAlertController(title: "Logout Confirmation", message: "Do you want to logout for sure ?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default) { _ in
            print("Logging out")
            UserDefaults.standard.set(nil, forKey: GlobalConstants.currentUserId)
            (UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate).changeRootViewController(LoginViewController(style: .insetGrouped))
        })
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        self.present(alert, animated: true)
    }
    
    @objc func onThemeSelection(_ sender: UISegmentedControl)
    {
        (UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate).changeTheme(themeOption: sender.selectedSegmentIndex)
    }
    
    @objc func onContextSaveAction(notification: NSNotification)
    {
        setUserDetails()
        print("Updated User Details: \(String(describing: user))")
    }
}

extension ProfileViewController: LanguageSelectionDelegate
{
    func onLanguageSelection(selectedLanguages: [Int16])
    {
        
    }
    
    func languageCellsWillLoad()
    {
        languageSelectionVC.setSelectedLanguages(languages: user.preferredLanguages!)
    }
}

extension ProfileViewController: GenreSelectionDelegate
{
    func onGenreSelection(selectedGenres: [Int16])
    {
        
    }
}
