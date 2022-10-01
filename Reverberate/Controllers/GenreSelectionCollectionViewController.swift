//
//  GenreSelectionCollectionViewController.swift
//  Reverberate
//
//  Created by arun-13930 on 08/07/22.
//

import UIKit

class GenreSelectionCollectionViewController: UICollectionViewController
{
    private let availableGenres: [[Int16]] = [[0, 1], [2, 3], [4]]
    
    private var selectedGenres: [Int16] = []
    
    weak var delegate: GenreSelectionDelegate?
    
    var areCellsPreselected: Bool = false
    
    var preSelectedGenres: [Int16]!
    
    var leftBarButtonType: UIBarButtonItem.SystemItem?
    
    var leftBarButtonCustomTitle: String?
    
    var rightBarButtonType: UIBarButtonItem.SystemItem?
    
    var rightBarButtonCustomTitle: String?
    
    private var selectAllBarButton: UIBarButtonItem!
    
    private var unselectAllBarButton: UIBarButtonItem!
    
    private var selectionTrackerBarItem: UIBarButtonItem!
    
    private var selectionTrackerLabel: UILabel = {
        let stLabel = UILabel(frame: .zero)
        stLabel.font = .preferredFont(forTextStyle: .body, weight: .semibold)
        stLabel.textColor = .label
        stLabel.adjustsFontSizeToFitWidth = false
        stLabel.enableAutoLayout()
        stLabel.textAlignment = .center
        return stLabel
    }()
    
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
        title = "Pick your Favourite Music Genres"
        setupNavBar()
        collectionView.register(SelectionCardCVCell.self, forCellWithReuseIdentifier: SelectionCardCVCell.identifier)
        collectionView.allowsMultipleSelection = true
        clearsSelectionOnViewWillAppear = false
        if areCellsPreselected
        {
            selectedGenres = preSelectedGenres
        }
        resetBarButtons()
    }
    
    private func resetBarButtons()
    {
        if selectedGenres.isEmpty
        {
            selectionTrackerLabel.text = "Select Genres"
            selectAllBarButton.isEnabled = true
            unselectAllBarButton.isEnabled = false
        }
        else
        {
            let count = selectedGenres.count
            selectionTrackerLabel.text = count == 1 ? "1 Genre Selected" : "\(count) Genres Selected"
            if count < availableGenres.flatMap({ $0 }).count
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
        rightBarButton.isEnabled = !selectedGenres.isEmpty
        if areCellsPreselected
        {
            rightBarButton.isEnabled = rightBarButton.isEnabled && selectedGenres.sorted() != preSelectedGenres.sorted()
        }
    }
    
    private func setupNavBar()
    {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 23, weight: .bold)]
        selectAllBarButton = UIBarButtonItem(title: "Select All", style: .plain, target: self, action: #selector(onSelectAllButtonTap(_:)))
        unselectAllBarButton = UIBarButtonItem(title: "Unselect All", style: .plain, target: self, action: #selector(onUnselectAllButtonTap(_:)))
        selectionTrackerBarItem = UIBarButtonItem(customView: selectionTrackerLabel)
        navigationController?.isToolbarHidden = false
        setToolbarItems([unselectAllBarButton,
                         flexibleSpace,
                         selectionTrackerBarItem,
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
            navigationItem.rightBarButtonItem!.isEnabled = false
        }
        else if rightBarButtonCustomTitle != nil
        {
            if rightBarButtonCustomTitle == "Next"
            {
                rightBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(onNextButtonTap(_:)))
                navigationItem.rightBarButtonItem = rightBarButton
            }
            navigationItem.rightBarButtonItem!.isEnabled = false
        }
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        delegate?.onGenreSelectionDismissRequest()
        super.viewDidDisappear(animated)
    }
    
    deinit
    {
        LifecycleLogger.deinitLog(self)
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return availableGenres.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return availableGenres[section].count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectionCardCVCell.identifier, for: indexPath) as! SelectionCardCVCell
        let genre = MusicGenre(rawValue: availableGenres[indexPath.section][indexPath.item])!
        cell.configureCell(title: nil, centerText: genre.description, backgroundColor: genre.preferredBackgroundColor)
        if areCellsPreselected
        {
            if preSelectedGenres.contains(genre.rawValue)
            {
                collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
            }
        }
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        selectedGenres.append(availableGenres[indexPath.section][indexPath.item])
        print(selectedGenres)
        resetBarButtons()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath)
    {
        selectedGenres.remove(at: selectedGenres.firstIndex(of: availableGenres[indexPath.section][indexPath.item])!)
        print(selectedGenres)
        resetBarButtons()
    }

}

extension GenreSelectionCollectionViewController: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let cellWidth = (view.frame.width / 2.5) - 1
        return .init(width: cellWidth, height: cellWidth / 1.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return .init(top: 10, left: 15, bottom: 10, right: 15)
    }
}

extension GenreSelectionCollectionViewController
{
    @objc func onUnselectAllButtonTap(_ sender: UIBarButtonItem)
    {
        for x in 0..<availableGenres.count
        {
            for y in 0..<availableGenres[x].count
            {
                let indexPath = IndexPath(item: y, section: x)
                collectionView.deselectItem(at: indexPath, animated: true)
                selectedGenres.removeAll()
            }
        }
        print(selectedGenres)
        resetBarButtons()
    }
    
    @objc func onSelectAllButtonTap(_ sender: UIBarButtonItem)
    {
        for x in 0..<availableGenres.count
        {
            for y in 0..<availableGenres[x].count
            {
                let indexPath = IndexPath(item: y, section: x)
                collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
                let genre = availableGenres[x][y]
                if !selectedGenres.contains(genre)
                {
                    selectedGenres.append(genre)
                }
            }
        }
        print(selectedGenres)
        resetBarButtons()
    }
    
    @objc func onCancelButtonTap(_ sender: UIBarButtonItem)
    {
        delegate?.onGenreSelectionDismissRequest()
    }
    
    @objc func onPreviousButtonTap(_ sender: UIBarButtonItem)
    {
        delegate?.onGenreSelectionDismissRequest()
    }
    
    @objc func onDoneButtonTap(_ sender: UIBarButtonItem)
    {
        self.delegate?.onGenreSelection(selectedGenres: selectedGenres)
    }
    
    @objc func onNextButtonTap(_ sender: UIBarButtonItem)
    {
        self.delegate?.onGenreSelection(selectedGenres: selectedGenres)
    }
}
