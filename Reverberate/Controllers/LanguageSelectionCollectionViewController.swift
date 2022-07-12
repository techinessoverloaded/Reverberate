//
//  LanguageSelectionCollectionViewController.swift
//  Reverberate
//
//  Created by arun-13930 on 08/07/22.
//

import UIKit

class LanguageSelectionCollectionViewController: UICollectionViewController
{
    private let availableLanguages: [[Int16]] = [[], [0, 1], [2, 3], [4, 5]]
    
    private var selectedLanguages: [Int16] = []
    
    weak var delegate: LanguageSelectionDelegate?
    
    private weak var nextButtonRef: UIButton?
    
    private var areCellsPreselected: Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.collectionView!.register(TitleButtonBarCollectionViewCell.self, forCellWithReuseIdentifier: TitleButtonBarCollectionViewCell.identifier)
        self.collectionView!.register(SelectionCardCVCell.self, forCellWithReuseIdentifier: SelectionCardCVCell.identifier)
        self.collectionView!.allowsMultipleSelection = true
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
        for language in languages
        {
            if !selectedLanguages.contains(language)
            {
                //selectedLanguages.append(language)
                for indexPath in collectionView.indexPathsForVisibleItems
                {
                    let section = indexPath.section
                    let item = indexPath.item
                    if section == 0
                    {
                        continue
                    }
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
        delegate?.languageCellsWillLoad()
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return availableLanguages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if section == 0
        {
            return 1
        }
        else
        {
            return availableLanguages[section].count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let section = indexPath.section
        if section == 0
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleButtonBarCollectionViewCell.identifier, for: indexPath) as! TitleButtonBarCollectionViewCell
            nextButtonRef = cell.configureCell(title: "Select your Favourite Languages", leftButtonTitle: nil, buttonTarget: self, leftButtonAction: nil, rightButtonTitle: "Next", rightButtonAction: #selector(onNextButtonTap(_:))).rightButtonRef
            nextButtonRef?.isEnabled = false
            return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectionCardCVCell.identifier, for: indexPath) as! SelectionCardCVCell
            let language = Language(rawValue: availableLanguages[section][indexPath.item])
            let (title, subtitle) = language!.titleAndLetter
            return cell.configureCell(title: title, centerText: subtitle, backgroundColor: language!.preferredBackgroundColor)
        }
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool
    {
        return indexPath.section != 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        print("Selection \(indexPath)")
        selectedLanguages.append(availableLanguages[indexPath.section][indexPath.item])
        print(selectedLanguages)
        nextButtonRef?.isEnabled = !selectedLanguages.isEmpty
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath)
    {
        print("Deselection \(indexPath)")
        selectedLanguages.remove(at: selectedLanguages.firstIndex(of: availableLanguages[indexPath.section][indexPath.item])!)
        print(selectedLanguages)
        nextButtonRef?.isEnabled = !selectedLanguages.isEmpty
    }
}

extension LanguageSelectionCollectionViewController: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if indexPath.section == 0
        {
            let cellWidth = view.frame.width - 2
            let cellHeight = view.frame.height / 8
            return .init(width: cellWidth, height: cellHeight)
        }
        else
        {
            //let noOfItemsPerSection: CGFloat = 2
            //let interItemSpacing: CGFloat = 5
//            let cellWidth = (collectionView.frame.width -
//                             (noOfItemsPerSection - 1) * interItemSpacing) / noOfItemsPerSection
            let cellWidth = (view.frame.width / 2.5) - 1
            return .init(width: cellWidth, height: cellWidth / 1.2)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return .init(top: 10, left: 20, bottom: 10, right: 20)
    }
}

extension LanguageSelectionCollectionViewController
{
    @objc func onNextButtonTap(_ sender: UIButton)
    {
        self.delegate?.onLanguageSelection(selectedLanguages: selectedLanguages)
    }
}
