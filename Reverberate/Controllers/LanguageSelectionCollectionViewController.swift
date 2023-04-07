//
//  LanguageSelectionCollectionViewController.swift
//  Reverberate
//
//  Created by arun-13930 on 08/07/22.
//

import UIKit

class LanguageSelectionCollectionViewController: UICollectionViewController
{
    private let availableLanguages: [[Int16]] = [[0, 1], [2, 3], [4]]
    
    private var selectedLanguages: [Int16] = []
    
    var preSelectedLanguages: [Int16]!
    
    weak var delegate: LanguageSelectionDelegate?
    
    var areCellsPreselected: Bool = false
    
    var leftBarButtonType: UIBarButtonItem.SystemItem?
    
    var leftBarButtonCustomTitle: String?
    
    var rightBarButtonType: UIBarButtonItem.SystemItem?
    
    var rightBarButtonCustomTitle: String?
    
    var selectAllBarButton: UIBarButtonItem!
    
    private var unselectAllBarButton: UIBarButtonItem!
    
//    private var selectionTrackerBarItem: UIBarButtonItem!
//
//    private var selectionTrackerLabel: UILabel = {
//        let stLabel = UILabel(frame: .zero)
//        stLabel.font = .preferredFont(forTextStyle: .subheadline, weight: .semibold)
//        stLabel.textColor = .label
//        stLabel.adjustsFontSizeToFitWidth = false
//        stLabel.enableAutoLayout()
//        stLabel.textAlignment = .center
//        return stLabel
//    }()
    
    private var flexibleSpace: UIBarButtonItem
    {
        get
        {
            return UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        }
    }
    
    var rightBarButton: UIBarButtonItem!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        title = "Pick your Favourite Languages"
        setupNavBar()
        collectionView.register(SelectionCardCVCell.self, forCellWithReuseIdentifier: SelectionCardCVCell.identifier)
        collectionView.allowsMultipleSelection = true
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        clearsSelectionOnViewWillAppear = false
        if preSelectedLanguages != nil
        {
            selectedLanguages = preSelectedLanguages
        }
        resetBarButtons()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        coordinator.animate(alongsideTransition: { [unowned self] _ in
            collectionViewLayout.invalidateLayout()
        })
    }
    
    private func resetBarButtons()
    {
        if selectedLanguages.isEmpty
        {
            //selectionTrackerLabel.text = "Select Languages"
            selectAllBarButton.isEnabled = true
            unselectAllBarButton.isEnabled = false
        }
        else
        {
            let count = selectedLanguages.count
            //selectionTrackerLabel.text = count == 1 ? "1 Language Selected" : "\(count) Languages Selected"
            if count < availableLanguages.flatMap({ $0 }).count
            {
                selectAllBarButton.isEnabled = true
                unselectAllBarButton.isEnabled = true
            }
            else
            {
                unselectAllBarButton.isEnabled = true
                selectAllBarButton.isEnabled = false
            }
        }
        rightBarButton.isEnabled = !selectedLanguages.isEmpty
        if areCellsPreselected
        {
            rightBarButton.isEnabled = rightBarButton.isEnabled && selectedLanguages.sorted() != preSelectedLanguages.sorted()
        }
    }
    
    private func setupNavBar()
    {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 23, weight: .bold)]
        selectAllBarButton = UIBarButtonItem(title: "Select All", style: .plain, target: self, action: #selector(onSelectAllButtonTap(_:)))
        unselectAllBarButton = UIBarButtonItem(title: "Unselect All", style: .plain, target: self, action: #selector(onUnselectAllButtonTap(_:)))
        //selectionTrackerBarItem = UIBarButtonItem(customView: selectionTrackerLabel)
        navigationController?.isToolbarHidden = false
        setToolbarItems([unselectAllBarButton,
                         flexibleSpace,
                         selectAllBarButton], animated: true)
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
        else
        {
            navigationController?.isModalInPresentation = true
        }
        if rightBarButtonType != nil
        {
            if rightBarButtonType == .done
            {
                rightBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(onDoneButtonTap(_:)))
                navigationItem.rightBarButtonItem = rightBarButton
            }
            rightBarButton.isEnabled = false
        }
        else if rightBarButtonCustomTitle != nil
        {
            if rightBarButtonCustomTitle == "Next"
            {
                rightBarButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(onNextButtonTap(_:)))
                navigationItem.rightBarButtonItem = rightBarButton
            }
            rightBarButton.isEnabled = false
        }
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        delegate?.onLanguageSelectionDismissRequest()
        super.viewDidDisappear(animated)
    }
    
    deinit
    {
        LifecycleLogger.deinitLog(self)
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
        let language = Language(rawValue: availableLanguages[indexPath.section][indexPath.item])!
        let (title, subtitle) = language.titleAndScript
        cell.configureCell(title: title, centerText: subtitle, backgroundColor: language.preferredBackgroundColor)
        if areCellsPreselected
        {
            if preSelectedLanguages.contains(language.rawValue)
            {
                collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
            }
        }
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        print("Selection \(indexPath)")
        selectedLanguages.append(availableLanguages[indexPath.section][indexPath.item])
        print(selectedLanguages)
        resetBarButtons()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath)
    {
        print("Deselection \(indexPath)")
        selectedLanguages.remove(at: selectedLanguages.firstIndex(of: availableLanguages[indexPath.section][indexPath.item])!)
        print(selectedLanguages)
        resetBarButtons()
    }
}

extension LanguageSelectionCollectionViewController: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let cellWidth = (collectionView.bounds.width / 2.3)//(view.frame.width / 2.5) - 1
        return .init(width: cellWidth, height: cellWidth / 1.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return .init(top: 10, left: 0, bottom: 10, right: 0)
    }
}

extension LanguageSelectionCollectionViewController
{
    @objc func onUnselectAllButtonTap(_ sender: UIBarButtonItem)
    {
        for x in 0..<availableLanguages.count
        {
            for y in 0..<availableLanguages[x].count
            {
                let indexPath = IndexPath(item: y, section: x)
                collectionView.deselectItem(at: indexPath, animated: true)
                selectedLanguages.removeAll()
                print(selectedLanguages)
            }
        }
        resetBarButtons()
    }
    
    @objc func onSelectAllButtonTap(_ sender: UIBarButtonItem)
    {
        for x in 0..<availableLanguages.count
        {
            for y in 0..<availableLanguages[x].count
            {
                let indexPath = IndexPath(item: y, section: x)
                collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
                let language = availableLanguages[x][y]
                if !selectedLanguages.contains(language)
                {
                    selectedLanguages.append(language)
                    print(selectedLanguages)
                }
            }
        }
        resetBarButtons()
    }
    
    @objc func onCancelButtonTap(_ sender: UIBarButtonItem)
    {
        delegate?.onLanguageSelectionDismissRequest()
    }
    
    @objc func onPreviousButtonTap(_ sender: UIBarButtonItem)
    {
        delegate?.onLanguageSelectionDismissRequest()
    }
    
    @objc func onDoneButtonTap(_ sender: UIBarButtonItem)
    {
        self.delegate?.onLanguageSelection(selectedLanguages: selectedLanguages)
    }
    
    @objc func onNextButtonTap(_ sender: UIBarButtonItem)
    {
        self.delegate?.onLanguageSelection(selectedLanguages: selectedLanguages)
    }
}
