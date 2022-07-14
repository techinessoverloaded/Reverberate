//
//  EditProfileViewController.swift
//  Reverberate
//
//  Created by arun-13930 on 11/07/22.
//

import UIKit
import CoreData
import PhotosUI

class EditProfileViewController: UITableViewController
{
    weak var userRef: User!
    
    private let contextSaveAction = (UIApplication.shared.delegate as! AppDelegate).saveContext
    
    private let profilePictureView: UIImageView = {
        let pView = UIImageView(useAutoLayout: true)
        pView.layer.borderWidth = 4
        pView.layer.borderColor = UIColor.systemBlue.cgColor
        pView.backgroundColor = .clear
        pView.contentMode = .scaleAspectFill
        pView.addButtonToImageView(title: "Change")
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
    
    private var profilePictureHasChanged: Bool = false
    
    private var tapGestureRecognizer: UITapGestureRecognizer!
    
    private var userProfilePicture: UIImage!
    
    private var nameHasError: Bool = false
    
    private var emailHasError: Bool = false
    
    private var phoneHasErrror: Bool = false
    
    private var profilePictureHasError: Bool = false
    
    private lazy var phPickerViewController: PHPickerViewController = {
        var pickerConfig = PHPickerConfiguration(photoLibrary: .shared())
        pickerConfig.selectionLimit = 1
        pickerConfig.filter = .images
        let picker = PHPickerViewController(configuration: pickerConfig)
        return picker
    }()
    
    override func loadView()
    {
        super.loadView()
        title = "Edit Profile"
        navigationItem.largeTitleDisplayMode = .never
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            phoneField.addReturnButtonToKeyboard(target: self, action: #selector(onCustomReturnButtonTap(_:)), title: "done")
        }
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
        doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(onDoneButtonTap(_:)))
        cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(onCancelButtonTap(_:)))
        doneButton.isEnabled = false
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = doneButton
        setupInitialData()
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onImageViewTap(_:)))
        profilePictureView.isUserInteractionEnabled = true
        profilePictureView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        profilePictureView.layer.cornerRadius = profilePictureView.bounds.height / 2
        profilePictureView.layer.cornerCurve = .circular
    }
    
    func setupInitialData()
    {
        nameField.text = userRef.name
        phoneField.text = userRef.phone
        emailField.text = userRef.email
        userProfilePicture = UIImage(data: userRef.profilePicture!)
        profilePictureView.image = userProfilePicture
    }
    
    func toggleDoneButtonEnabled()
    {
        doneButton.isEnabled = (nameHasChanged || emailHasChanged || phoneHasChanged || profilePictureHasChanged) && !(nameHasError || phoneHasErrror || emailHasError || profilePictureHasError)
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
            return 130
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
                cell.configureCell(title: "Name", infoView: nameField, spreadInfoViewFromLeftEnd: true)
                return cell
            case 1:
                cell.configureCell(title: "Phone Number", infoView: phoneField, spreadInfoViewFromLeftEnd: true)
                return cell
            case 2:
                cell.configureCell(title: "Email Address", infoView: emailField, spreadInfoViewFromLeftEnd: true)
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
            var name = textField.text ?? ""
            name.trim()
            let cell = tableView.cellForRow(at: IndexPath(item: 0, section: 1)) as! LabeledInfoTableViewCell
            print(cell)
            if name.isEmpty
            {
                cell.setError(isErrorPresent: true, message: "Name Required")
            }
            else if !InputValidator.validateName(name)
            {
                cell.setError(isErrorPresent: true, message: "Invalid Name")
            }
            else
            {
                cell.setError(isErrorPresent: false)
            }
            nameHasChanged = textField.text != userRef.name
            nameHasError = cell.hasError
        }
        else if textField === phoneField
        {
            var phone = textField.text ?? ""
            phone.trim()
            let cell = tableView.cellForRow(at: IndexPath(item: 1, section: 1)) as! LabeledInfoTableViewCell
            if phone.isEmpty
            {
                cell.setError(isErrorPresent: true, message: "Phone Required")
            }
            else if !InputValidator.validatePhone(phone)
            {
                cell.setError(isErrorPresent: true, message: "Invalid Phone")
            }
            else
            {
                cell.setError(isErrorPresent: false)
            }
            phoneHasChanged = textField.text != userRef.phone
            phoneHasErrror = cell.hasError
        }
        else
        {
            var email = textField.text ?? ""
            email.trim()
            let cell = tableView.cellForRow(at: IndexPath(item: 2, section: 1)) as! LabeledInfoTableViewCell
            if email.isEmpty
            {
                cell.setError(isErrorPresent: true, message: "Email Required")
            }
            else if !InputValidator.validateEmail(email)
            {
                cell.setError(isErrorPresent: true, message: "Invalid Email")
            }
            else
            {
                cell.setError(isErrorPresent: false)
            }
            emailHasChanged = textField.text != userRef.email
            emailHasError = cell.hasError
        }
        toggleDoneButtonEnabled()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        return textField.resignFirstResponder()
    }
}

extension EditProfileViewController
{
    @objc func onImageViewTap(_ sender: UITapGestureRecognizer)
    {
        print("On Image View Tap")
        if nameField.isFirstResponder
        {
            nameField.resignFirstResponder()
        }
        if phoneField.isFirstResponder
        {
            phoneField.resignFirstResponder()
        }
        if emailField.isFirstResponder
        {
            emailField.resignFirstResponder()
        }
        if phPickerViewController.delegate == nil
        {
            phPickerViewController.delegate = self
        }
        self.present(phPickerViewController, animated: true)
    }
    
    @objc func onCustomReturnButtonTap(_ sender: UIBarButtonItem)
    {
        phoneField.resignFirstResponder()
    }
    
    @objc func onCancelButtonTap(_ sender: UIBarButtonItem)
    {
        self.dismiss(animated: true)
    }
    
    @objc func onDoneButtonTap(_ sender: UIBarButtonItem)
    {
        textFieldDidEndEditing(nameField)
        textFieldDidEndEditing(emailField)
        textFieldDidEndEditing(phoneField)
        if nameHasChanged
        {
            userRef.name = nameField.text!
        }
        if emailHasChanged
        {
            userRef.email = emailField.text!
        }
        if phoneHasChanged
        {
            userRef.phone = phoneField.text!
        }
        if profilePictureHasChanged
        {
            userRef.profilePicture = profilePictureView.image?.jpegData(compressionQuality: 1)
        }
        contextSaveAction()
        self.dismiss(animated: true)
    }
}

extension EditProfileViewController: PHPickerViewControllerDelegate
{
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult])
    {
        if results.isEmpty
        {
            DispatchQueue.main.async {
                picker.dismiss(animated: true)
            }
            return
        }
        results.first?.itemProvider.loadObject(ofClass: UIImage.self) { [unowned self] reading , error in
            guard let image = reading as? UIImage, error == nil else
            {
                DispatchQueue.main.async {
                    picker.dismiss(animated: true)
                    self.profilePictureHasError = true
                    self.toggleDoneButtonEnabled()
                }
                return
            }
            self.profilePictureHasError = false
            DispatchQueue.main.async {
                picker.dismiss(animated: true)
                self.profilePictureHasChanged = self.userProfilePicture != image
                if self.profilePictureHasChanged
                {
                    self.profilePictureView.image = image
                    self.toggleDoneButtonEnabled()
                }
            }
        }
    }
}
