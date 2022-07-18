//
//  InitialViewController.swift
//  Reverberate
//
//  Created by arun-13930 on 14/07/22.
//

import UIKit

class InitialViewController: UITableViewController
{

//    private lazy var blurView: UIVisualEffectView = {
//        let bView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
//        return bView
//    }()
    
    private lazy var introLabel: UILabel = {
        let iLabel = UILabel(useAutoLayout: true)
        iLabel.font = .systemFont(ofSize: 26, weight: .bold)
        iLabel.textColor = .white
        iLabel.textAlignment = .center
        iLabel.text = "Reverberate is ready to soothe your ears. \n \n Let's get started !"
        iLabel.numberOfLines = 4
        iLabel.enableAutoLayout()
        return iLabel
    }()
    
    private lazy var signupButton: UIButton = {
        var sButtonConfig = UIButton.Configuration.bordered()
        sButtonConfig.title = "Signup now"
        sButtonConfig.cornerStyle = .capsule
        sButtonConfig.baseForegroundColor = .white
        let sButton = UIButton(configuration: sButtonConfig)
        return sButton
    }()
    
    private lazy var loginButton: UIButton = {
        var lButtonConfig = UIButton.Configuration.bordered()
        lButtonConfig.title = "Login now"
        lButtonConfig.cornerStyle = .capsule
        lButtonConfig.baseForegroundColor = .white
        let lButton = UIButton(configuration: lButtonConfig)
        return lButton
    }()
    
    private lazy var guestButton: UIButton = {
        var gButtonConfig = UIButton.Configuration.bordered()
        gButtonConfig.title = "Continue as Guest"
        gButtonConfig.cornerStyle = .capsule
        gButtonConfig.baseForegroundColor = .white
        let gButton = UIButton(configuration: gButtonConfig)
        return gButton
    }()
    
    private lazy var backgroundView: UIImageView = {
        let backView = UIImageView(image: UIImage(named: "dark_gradient_bg")!)
        backView.contentMode = .scaleAspectFill
        return backView
    }()
    
    private lazy var logoView: UIImageView = {
        let logoView = UIImageView(image: UIImage(named: "reverberate_logo_transparent")!)
        logoView.contentMode = .scaleAspectFill
        logoView.enableAutoLayout()
        return logoView
    }()
    
    private var languageSelectionVC: LanguageSelectionCollectionViewController!
    
    private var genreSelectionVC: GenreSelectionCollectionViewController!
    
    private var loginController: LoginViewController!
    
    private var signupController: SignupViewController!
    
    private var inSignupMode: Bool = false
    
    private var inGuestMode: Bool = false
    
    private lazy var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var user: User!
    
    private lazy var contextSaveAction = (UIApplication.shared.delegate as! AppDelegate).saveContext
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        print("Initial View Controller")
        tableView.backgroundColor = .clear
        //blurView.frame = backgroundView.bounds
        //blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //backgroundView.addSubview(blurView)
        tableView.backgroundView = backgroundView
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        tableView.separatorColor = .clear
        signupButton.addTarget(self, action: #selector(onSignupButtonTap(_:)), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(onLoginButtonTap(_:)), for: .touchUpInside)
        guestButton.addTarget(self, action: #selector(onGuestButtonTap(_:)), for: .touchUpInside)
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
    }

    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        tableView.scrollToRow(at: IndexPath(item: 0, section: 5), at: .bottom, animated: true)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        coordinator.animateAlongsideTransition(in: tableView)
        {   [unowned self] _ in
            self.tableView.scrollToRow(at: IndexPath(item: 0, section: 5), at: .bottom, animated: true)
        }
    }
    
    func showLoginViewController()
    {
        loginController = LoginViewController(style: .insetGrouped)
        loginController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(onLoginCancel(_:)))
        loginController.delegate = self
        let navController = UINavigationController(rootViewController: loginController)
        navController.modalPresentationStyle = .pageSheet
        navController.isModalInPresentation = true
        self.present(navController, animated: true)
    }
    
    func showSignupViewController()
    {
        signupController = SignupViewController(style: .insetGrouped)
        signupController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(onSignupCancel(_:)))
        signupController.delegate = self
        let navController = UINavigationController(rootViewController: signupController)
        navController.modalPresentationStyle = .pageSheet
        navController.isModalInPresentation = true
        self.present(navController, animated: true)
    }
    
    func showLanguageSelectionViewController(shouldShowCancelButton: Bool = false)
    {
        languageSelectionVC = LanguageSelectionCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        languageSelectionVC.delegate = self
        languageSelectionVC.rightBarButtonCustomTitle = "Next"
        if shouldShowCancelButton
        {
            languageSelectionVC.leftBarButtonType = .cancel
        }
        let navController = UINavigationController(rootViewController: languageSelectionVC)
        navController.modalPresentationStyle = .pageSheet
        navController.isModalInPresentation = true
        self.present(navController, animated: true)
    }
    
    func showGenreSelectionViewController(shouldShowCancelButton: Bool = false)
    {
        genreSelectionVC = GenreSelectionCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        genreSelectionVC.delegate = self
        genreSelectionVC.rightBarButtonType = .done
        if shouldShowCancelButton
        {
            genreSelectionVC.leftBarButtonType = .cancel
        }
        let navController = UINavigationController(rootViewController: genreSelectionVC)
        navController.modalPresentationStyle = .pageSheet
        navController.isModalInPresentation = true
        self.present(navController, animated: true)
    }
    
    func fetchUser()
    {
        user = try! context.fetch(User.fetchRequest()).first {
            $0.id == UserDefaults.standard.string(forKey: GlobalConstants.currentUserId)
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 6
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0
        {
            return tableView.bounds.height * 0.15
        }
        else if indexPath.section == 1
        {
            return 180
        }
        else if indexPath.section == 2
        {
            return 140
        }
        else
        {
            return tableView.estimatedRowHeight
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as! CustomTableViewCell
        let section = indexPath.section
        cell.selectionStyle = .none
        if section == 0
        {
            let dummyView = UIView()
            dummyView.backgroundColor = .clear
            cell.addSubViewToContentView(dummyView)
            return cell
        }
        else if section == 1
        {
            cell.addSubViewToContentView(logoView, useAutoLayout: true)
            return cell
        }
        else if section == 2
        {
            cell.addSubViewToContentView(introLabel, useAutoLayout: true)
            return cell
        }
        else if section == 3
        {
            cell.addSubViewToContentView(signupButton)
            return cell
        }
        else if section == 4
        {
            cell.addSubViewToContentView(loginButton)
            return cell
        }
        else
        {
            cell.addSubViewToContentView(guestButton)
            return cell
        }
    }
}

// Obj-C Methods
extension InitialViewController
{
    @objc func onSignupButtonTap(_ sender: UIButton)
    {
        showSignupViewController()
        inSignupMode = true
        inGuestMode = false
    }
    
    @objc func onLoginButtonTap(_ sender: UIButton)
    {
        showLoginViewController()
    }
    
    @objc func onGuestButtonTap(_ sender: UIButton)
    {
        let alreadySelectedLanguages = UserDefaults.standard.object(forKey: GlobalConstants.preferredLanguages) as! [Int16]
        let alreadySelectedGenres = UserDefaults.standard.object(forKey: GlobalConstants.preferredGenres) as! [Int16]
        if alreadySelectedLanguages.isEmpty
        {
            showLanguageSelectionViewController(shouldShowCancelButton: true)
            inGuestMode = true
        }
        else
        {
            if alreadySelectedGenres.isEmpty
            {
                showGenreSelectionViewController(shouldShowCancelButton: true)
                inGuestMode = true
            }
            else
            {
                (UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate).changeRootViewController(MainViewController())
                UserDefaults.standard.set(false, forKey: GlobalConstants.isFirstTime)
            }
        }
    }
    
    @objc func onSignupCancel(_ sender: UIBarButtonItem)
    {
        signupController.dismiss(animated: true)
        signupController = nil
        user = nil
        inSignupMode = false
    }
    
    @objc func onLoginCancel(_ sender: UIBarButtonItem)
    {
        loginController.dismiss(animated: true)
        loginController = nil
    }
}

extension InitialViewController: SignupDelegate
{
    func onSuccessfulSignup()
    {
        fetchUser()
        signupController.dismiss(animated: true) {
            [unowned self] in
            self.showLanguageSelectionViewController()
        }
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

extension InitialViewController: LoginDelegate
{
    func onSuccessfulLogin()
    {
        UserDefaults.standard.set(false, forKey: GlobalConstants.isFirstTime)
        loginController.dismiss(animated: true) {
            (UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate).changeRootViewController(MainViewController())
        }
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

extension InitialViewController: LanguageSelectionDelegate
{
    func onLanguageSelection(selectedLanguages: [Int16])
    {
        if inSignupMode
        {
            user.preferredLanguages = selectedLanguages
            contextSaveAction()
            languageSelectionVC.dismiss(animated: true) {
                [unowned self] in
                self.showGenreSelectionViewController()
            }
        }
        else if inGuestMode
        {
            UserDefaults.standard.set(selectedLanguages, forKey: GlobalConstants.preferredLanguages)
            languageSelectionVC.dismiss(animated: true) {
                [unowned self] in
                self.showGenreSelectionViewController(shouldShowCancelButton: true)
            }
        }
    }
}

extension InitialViewController: GenreSelectionDelegate
{
    func onGenreSelection(selectedGenres: [Int16])
    {
        if inSignupMode
        {
            user.preferredGenres = selectedGenres
            contextSaveAction()
            genreSelectionVC.dismiss(animated: true) {
                (UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate).changeRootViewController(MainViewController())
            }
        }
        else if inGuestMode
        {
            UserDefaults.standard.set(selectedGenres, forKey: GlobalConstants.preferredGenres)
            UserDefaults.standard.set(false, forKey: GlobalConstants.isFirstTime)
            genreSelectionVC.dismiss(animated: true) {
                (UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate).changeRootViewController(MainViewController())
            }
        }
    }
}
