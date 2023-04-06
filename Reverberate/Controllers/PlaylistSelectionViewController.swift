//
//  PlaylistSelectionViewController.swift
//  Reverberate
//
//  Created by arun-13930 on 09/09/22.
//

import UIKit

class PlaylistSelectionViewController: UITableViewController
{
    private lazy var allPlaylists: [Playlist] = GlobalVariables.shared.currentUser!.playlists! 
    
    private lazy var backgroundView: UIView = isTranslucent ? UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterial)) : UIView()
    
    private lazy var noPlaylistsMessage: NSAttributedString = {
        let largeTextAttributes: [NSAttributedString.Key : Any] =
        [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 19, weight: .bold),
            NSAttributedString.Key.foregroundColor : UIColor.label
        ]
        let smallerTextAttributes: [NSAttributedString.Key : Any] =
        [
            NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: .body),
            NSAttributedString.Key.foregroundColor : UIColor.secondaryLabel
        ]
        var mutableAttrString = NSMutableAttributedString(string: "No Playlists were found\n\n", attributes: largeTextAttributes)
        mutableAttrString.append(NSMutableAttributedString(string: "Try adding some Playlists.", attributes: smallerTextAttributes))
        return mutableAttrString
    }()
    
    private lazy var emptyMessageLabel: UILabel = {
        let emLabel = UILabel(useAutoLayout: true)
        emLabel.textAlignment = .center
        emLabel.numberOfLines = 4
        return emLabel
    }()
    
    private var selectedPlaylist: Playlist? = nil
    
    private var doneButton: UIBarButtonItem!
    
    private var addButton: UIBarButtonItem!
    
    var isTranslucent: Bool = false
    
    weak var delegate: PlaylistSelectionDelegate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        title = "Choose a Playlist"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(onCancelButtonTap))
        doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(onDoneButtonTap))
        addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onCreatePlaylistButtonTap))
        navigationItem.rightBarButtonItems = [
            doneButton,
            addButton
        ]
        doneButton.isEnabled = selectedPlaylist != nil
        if isTranslucent
        {
            tableView.backgroundColor = .clear
            view.backgroundColor = .clear
            (backgroundView as! UIVisualEffectView).contentView.addSubview(emptyMessageLabel)
        }
        else
        {
            tableView.backgroundColor = .systemGroupedBackground
            backgroundView.addSubview(emptyMessageLabel)
        }
        NSLayoutConstraint.activate([
            emptyMessageLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            emptyMessageLabel.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            emptyMessageLabel.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 0.8)
        ])
        emptyMessageLabel.attributedText = noPlaylistsMessage
        emptyMessageLabel.isHidden = !allPlaylists.isEmpty
        tableView.backgroundView = backgroundView
    }
    
    private func fetchPlaylists()
    {
        allPlaylists = GlobalVariables.shared.currentUser!.playlists! 
        tableView.reloadData()
    }

    private func showCreationError(message: String)
    {
        let errorAlert = UIAlertController(title: "Failed to create Playlist", message: "\(message)\n Try creating a Playlist Again.", preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { _ in
            DispatchQueue.main.async { [unowned self] in
                self.onCreatePlaylistButtonTap()
            }
        }))
        errorAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        self.present(errorAlert, animated: true)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return allPlaylists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = indexPath.item
        let playlist = allPlaylists[item]
        var config = cell.defaultContentConfiguration()
        config.text = playlist.name!
        config.secondaryText = "\(playlist.songs?.count ?? 0) Songs"
        config.textProperties.adjustsFontForContentSizeCategory = true
        config.textProperties.allowsDefaultTighteningForTruncation = true
        config.secondaryTextProperties.adjustsFontForContentSizeCategory = true
        config.secondaryTextProperties.color = .secondaryLabel
        config.secondaryTextProperties.allowsDefaultTighteningForTruncation = true
        config.secondaryTextProperties.font = .preferredFont(forTextStyle: .footnote)
        cell.contentConfiguration = config
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let item = indexPath.item
        let playlist = allPlaylists[item]
        let cell = tableView.cellForRow(at: indexPath)!
        cell.accessoryType = .checkmark
        selectedPlaylist = playlist
        doneButton.isEnabled = selectedPlaylist != nil
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath)
    {
        let cell = tableView.cellForRow(at: indexPath)!
        cell.accessoryType = .none
        doneButton.isEnabled = selectedPlaylist != nil
    }
    
    deinit
    {
        LifecycleLogger.deinitLog(self)
    }
}

extension PlaylistSelectionViewController
{
    @objc func onCancelButtonTap()
    {
        self.dismiss(animated: true)
    }
    
    @objc func onCreatePlaylistButtonTap()
    {
        let alert = UIAlertController(title: "Create New Playlist", message: "Enter name of the New Playlist", preferredStyle: .alert)
        alert.addTextField()
        let nameField = alert.textFields![0]
        nameField.placeholder = "Name of Playlist"
        nameField.returnKeyType = .done
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [unowned self] _ in
            if nameField.text?.isEmpty ?? true
            {
                DispatchQueue.main.async { [unowned self] in
                    showCreationError(message: "Failed to create Playlist as no name was provided!")
                }
            }
            else if allPlaylists.contains(where: { $0.name! == nameField.text! })
            {
                DispatchQueue.main.async { [unowned self] in
                    showCreationError(message: "Failed to create Playlist as a Playlist exists with the same name already!")
                }
            }
            else
            {
                let newPlaylist = Playlist()
                newPlaylist.name = nameField.text!
                newPlaylist.songs = []
                GlobalVariables.shared.currentUser!.addToPlaylists(newPlaylist)
                print(GlobalVariables.shared.currentUser!.playlists!)
                DispatchQueue.main.async { [unowned self] in
                    self.fetchPlaylists()
                    emptyMessageLabel.isHidden = !allPlaylists.isEmpty
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        self.present(alert, animated: true)
    }
    
    @objc func onDoneButtonTap()
    {
        self.dismiss(animated: true, completion: { [unowned self] in
            delegate?.onPlaylistSelection(selectedPlaylist: selectedPlaylist!)
        })
    }
}
