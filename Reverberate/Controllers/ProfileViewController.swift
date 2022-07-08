//
//  ProfileViewController.swift
//  Reverberate
//
//  Created by arun-13930 on 07/07/22.
//

import UIKit

class ProfileViewController: UIViewController
{
    private var safeArea: UILayoutGuide!
    
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
    
    private let editProfileButton: UIButton = {
        var eButtonConfig = UIButton.Configuration.borderedTinted()
        eButtonConfig.title = "Edit Profile"
        let eButton = UIButton(configuration: eButtonConfig)
        eButton.enableAutoLayout()
        return eButton
    }()
    
    @objc private let logoutButton: UIButton = {
        var lButtonConfig = UIButton.Configuration.borderedTinted()
        lButtonConfig.title = "Logout"
        lButtonConfig.baseBackgroundColor = .systemRed
        lButtonConfig.baseForegroundColor = .systemRed
        let lButton = UIButton(configuration: lButtonConfig)
        lButton.enableAutoLayout()
        return lButton
    }()
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var user: User!
    
    override func loadView()
    {
        super.loadView()
        safeArea = view.safeAreaLayoutGuide
        view.addSubview(profilePictureView)
        view.addSubview(nameLabel)
        view.addSubview(editProfileButton)
        view.addSubview(logoutButton)
        NSLayoutConstraint.activate([
            profilePictureView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            profilePictureView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 60),
            nameLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: profilePictureView.bottomAnchor, constant: 10),
            editProfileButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            editProfileButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            logoutButton.topAnchor.constraint(equalTo: safeArea.topAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20)
        ])
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.prefersLargeTitles = true
        setUserDetails()
        editProfileButton.addTarget(self, action: #selector(onEditButtonTap(_:)), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(onLogoutButtonTap(_:)), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        profilePictureView.layer.cornerRadius = profilePictureView.bounds.height / 2
    }
    
    func setUserDetails()
    {
        user = try! context.fetch(User.fetchRequest()).first {
            $0.id == UserDefaults.standard.string(forKey: GlobalConstants.currentUserId)
        }
        nameLabel.text = user.name
    }
}

extension ProfileViewController
{
    @objc func onEditButtonTap(_ sender: UIButton)
    {
        print("Edit Profile Tapped")
    }
    
    @objc func onLogoutButtonTap(_ sender: UIButton)
    {
        print("Logging out")
        UserDefaults.standard.set(nil, forKey: GlobalConstants.currentUserId)
        (UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate).changeRootViewController(LoginViewController(style: .insetGrouped))
    }
}
