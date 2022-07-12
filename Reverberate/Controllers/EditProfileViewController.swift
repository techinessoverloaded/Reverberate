//
//  EditProfileViewController.swift
//  Reverberate
//
//  Created by arun-13930 on 11/07/22.
//

import UIKit
import CoreData

class EditProfileViewController: UITableViewController
{
    weak var userRef: User!
    
    private let contextSaveAction = (UIApplication.shared.delegate as! AppDelegate).saveContext
    
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
    
    private let nameField: UITextField = {
        let nField = UITextField(useAutoLayout: true)
        nField.clearButtonMode = .whileEditing
        nField.keyboardType = .namePhonePad
        nField.returnKeyType = .done
        nField.autocapitalizationType = .words
        nField.autocorrectionType = .no
        nField.textContentType = .name
        return nField
    }()
    
    private let emailField: UITextField = {
        let eField = UITextField(useAutoLayout: true)
        eField.clearButtonMode = .whileEditing
        eField.keyboardType = .emailAddress
        eField.returnKeyType = .done
        eField.autocapitalizationType = .none
        eField.autocorrectionType = .no
        eField.textContentType = .emailAddress
        return eField
    }()
    
    private let phoneField: UITextField = {
        let pField = UITextField(useAutoLayout: true)
        pField.clearButtonMode = .whileEditing
        pField.keyboardType = .phonePad
        pField.returnKeyType = .done
        pField.autocapitalizationType = .none
        pField.autocorrectionType = .no
        pField.textContentType = .telephoneNumber
        return pField
    }()
    
    private var doneButton: UIBarButtonItem!
    
    private var cancelButton: UIBarButtonItem!
    
    private var nameHasChanged: Bool = false
    
    private var emailHasChanged: Bool = false
    
    private var phoneHasChanged: Bool = false
    
    override func loadView()
    {
        super.loadView()
        title = "Edit Profile"
        navigationItem.largeTitleDisplayMode = .never
        doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(onDoneButtonTap(_:)))
        cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(onCancelButtonTap(_:)))
        doneButton.isEnabled = false
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = doneButton
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        tableView.register(LabeledInfoTableViewCell.self, forCellReuseIdentifier: LabeledInfoTableViewCell.identifier)
        tableView.allowsSelection = false
        nameField.delegate = self
        phoneField.delegate = self
        emailField.delegate = self
        setupInitialData()
    }
    
    func setupInitialData()
    {
        nameField.text = userRef.name
        phoneField.text = userRef.phone
        emailField.text = userRef.email
    }
}

// TableView Delegate and Datasource
extension EditProfileViewController
{
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0
        {
            return 150
        }
        else
        {
            return tableView.estimatedRowHeight
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let section = indexPath.section
        let item = indexPath.item
        if section == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as! CustomTableViewCell
            //Hide Separator
            cell.separatorInset = .init(top: 0, left: cell.contentView.bounds.width, bottom: 0, right: 0)
            cell.addSubViewToContentView(profilePictureView, useAutoLayout: true)
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: LabeledInfoTableViewCell.identifier, for: indexPath) as! LabeledInfoTableViewCell
            //Show separator
            cell.separatorInset = .zero
            switch item
            {
            case 0:
                cell.configureCell(title: "Name", infoView: nameField, spreadInfoViewFromLeftEnd: true, widthMultiplier: 0.77)
                return cell
            case 1:
                cell.configureCell(title: "Phone Number", infoView: phoneField, spreadInfoViewFromLeftEnd: true, widthMultiplier: 0.61)
                return cell
            case 2:
                cell.configureCell(title: "Email Address", infoView: emailField, spreadInfoViewFromLeftEnd: true, widthMultiplier: 0.621)
                return cell
                
            default:
                return cell
            }
        }
    }
}

extension EditProfileViewController: UITextFieldDelegate
{
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField === nameField
        {
            nameHasChanged = textField.text != userRef.name
        }
        else if textField === phoneField
        {
            phoneHasChanged = textField.text != userRef.phone
        }
        else
        {
            emailHasChanged = textField.text != userRef.email
        }
        doneButton.isEnabled = nameHasChanged || emailHasChanged || phoneHasChanged
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        return textField.resignFirstResponder()
    }
}

extension EditProfileViewController
{
    @objc func onCancelButtonTap(_ sender: UIBarButtonItem)
    {
        self.dismiss(animated: true)
    }
    
    @objc func onDoneButtonTap(_ sender: UIBarButtonItem)
    {
        userRef.name = nameField.text!.trimmingCharacters(in: .whitespaces)
        userRef.email = emailField.text!.trimmingCharacters(in: .whitespaces)
        userRef.phone = phoneField.text!.trimmingCharacters(in: .whitespaces)
        contextSaveAction()
        self.dismiss(animated: true)
    }
}
