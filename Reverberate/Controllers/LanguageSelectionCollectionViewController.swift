//
//  LanguageSelectionCollectionViewController.swift
//  Reverberate
//
//  Created by arun-13930 on 08/07/22.
//

import UIKit

class LanguageSelectionCollectionViewController: UICollectionViewController
{
    private let availableLanguages: [[Int16]] = [[0, 1], [2, 3], [4, 5]]
    
    private var selectedLanguages: [Int16] = []
    
    weak var delegate: LanguageSelectionDelegate?
    
    private var areCellsPreselected: Bool = false
    
    private var alreadySelectedLanguages: [Int16]?
    
    var leftBarButtonType: UIBarButtonItem.SystemItem?
    
    var leftBarButtonCustomTitle: String?
    
    var rightBarButtonType: UIBarButtonItem.SystemItem?
    
    var rightBarButtonCustomTitle: String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        title = "Select your Favourite Languages"
        setupNavBar()
        collectionView.register(SelectionCardCVCell.self, forCellWithReuseIdentifier: SelectionCardCVCell.identifier)
        collectionView.allowsMultipleSelection = true
    }
    
    func setupNavBar()
    {
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 24, weight: .bold)]
        if leftBarButtonType != nil
        {
            if leftBarButtonType == .cancel
            {
                navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(onCancelButtonTap(_:)))
            }
        }
        else if leftBarButtonCustomTitle != nil
        {
            if leftBarButtonCustomTitle == "Previous"
            {
                navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Previous", style: .plain, target: self, action: #selector(onPreviousButtonTap(_:)))
            }
        }
        if rightBarButtonType != nil
        {
            if rightBarButtonType == .done
            {
                navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(onDoneButtonTap(_:)))
            }
            navigationItem.rightBarButtonItem!.isEnabled = false
        }
        else if rightBarButtonCustomTitle != nil
        {
            if rightBarButtonCustomTitle == "Next"
            {
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(onNextButtonTap(_:)))
            }
            navigationItem.rightBarButtonItem!.isEnabled = false
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func setSelectedLanguages(languages: [Int16])
    {
        guard !languages.isEmpty else
        {
            return
        }
        areCellsPreselected = true
        alreadySelectedLanguages = languages
        for language in languages
        {
            if !selectedLanguages.contains(language)
            {
                //selectedLanguages.append(language)
                for indexPath in collectionView.indexPathsForVisibleItems
                {
                    let section = indexPath.section
                    let item = indexPath.item
                    if availableLanguages[section][item] == language
                    {
                        // Select
                        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
                        collectionView(collectionView, didSelectItemAt: indexPath)
                    }
                }
            }
        }
    }
    
    override func viewWillLayoutSubviews()
    {
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        delegate?.languageCellsDidLoad()
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return availableLanguages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return availableLanguages[section].count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectionCardCVCell.identifier, for: indexPath) as! SelectionCardCVCell
        let language = Language(rawValue: availableLanguages[indexPath.section][indexPath.item])
        let (title, subtitle) = language!.titleAndLetter
        return cell.configureCell(title: title, centerText: subtitle, backgroundColor: language!.preferredBackgroundColor)
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        print("Selection \(indexPath)")
        selectedLanguages.append(availableLanguages[indexPath.section][indexPath.item])
        print(selectedLanguages)
        navigationItem.rightBarButtonItem!.isEnabled = !selectedLanguages.isEmpty
        if areCellsPreselected
        {
            navigationItem.rightBarButtonItem!.isEnabled = navigationItem.rightBarButtonItem!.isEnabled && selectedLanguages.sorted() != alreadySelectedLanguages!.sorted()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath)
    {
        print("Deselection \(indexPath)")
        selectedLanguages.remove(at: selectedLanguages.firstIndex(of: availableLanguages[indexPath.section][indexPath.item])!)
        print(selectedLanguages)
        navigationItem.rightBarButtonItem!.isEnabled = !selectedLanguages.isEmpty
        if areCellsPreselected
        {
            navigationItem.rightBarButtonItem!.isEnabled = navigationItem.rightBarButtonItem!.isEnabled && selectedLanguages.sorted() != alreadySelectedLanguages!.sorted()
        }
    }
}

extension LanguageSelectionCollectionViewController: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        //let noOfItemsPerSection: CGFloat = 2
        //let interItemSpacing: CGFloat = 5
        //let cellWidth = (collectionView.frame.width -
//                             (noOfItemsPerSection - 1) * interItemSpacing) / noOfItemsPerSection
        let cellWidth = (view.frame.width / 2.5) - 1
        return .init(width: cellWidth, height: cellWidth / 1.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return .init(top: 10, left: 20, bottom: 10, right: 20)
    }
}

extension LanguageSelectionCollectionViewController
{
    @objc func onCancelButtonTap(_ sender: UIBarButtonItem)
    {
        self.dismiss(animated: true)
    }
    
    @objc func onPreviousButtonTap(_ sender: UIBarButtonItem)
    {
        self.dismiss(animated: true)
    }
    
    @objc func onDoneButtonTap(_ sender: UIBarButtonItem)
    {
        self.dismiss(animated: true)
        self.delegate?.onLanguageSelection(selectedLanguages: selectedLanguages)
    }
    
    @objc func onNextButtonTap(_ sender: UIBarButtonItem)
    {
        self.delegate?.onLanguageSelection(selectedLanguages: selectedLanguages)
    }
}
