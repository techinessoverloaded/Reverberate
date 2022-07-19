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
    
    private var areCellsPreselected: Bool = false
    
    private var alreadySelectedGenres: [Int16]?
    
    var leftBarButtonType: UIBarButtonItem.SystemItem?
    
    var leftBarButtonCustomTitle: String?
    
    var rightBarButtonType: UIBarButtonItem.SystemItem?
    
    var rightBarButtonCustomTitle: String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        title = "Pick your Favourite Music Genres"
        setupNavBar()
        collectionView.register(SelectionCardCVCell.self, forCellWithReuseIdentifier: SelectionCardCVCell.identifier)
        collectionView.allowsMultipleSelection = true
    }
    
    func setupNavBar()
    {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 23, weight: .bold)]
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
    
    func setSelectedGenres(genres: [Int16])
    {
        guard !genres.isEmpty else
        {
            return
        }
        areCellsPreselected = true
        alreadySelectedGenres = genres
        for genre in genres
        {
            if !selectedGenres.contains(genre)
            {
                //selectedGenres.append(genre)
                for indexPath in collectionView.indexPathsForVisibleItems
                {
                    let section = indexPath.section
                    let item = indexPath.item
                    if availableGenres[section][item] == genre
                    {
                        // Select
                        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
                        collectionView(collectionView, didSelectItemAt: indexPath)
                    }
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        delegate?.genreCellsDidLoad()
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
        let genre = MusicGenre(rawValue: availableGenres[indexPath.section][indexPath.item])
        return cell.configureCell(title: nil, centerText: genre!.description, backgroundColor: genre!.preferredBackgroundColor)
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        selectedGenres.append(availableGenres[indexPath.section][indexPath.item])
        print(selectedGenres)
        navigationItem.rightBarButtonItem!.isEnabled = !selectedGenres.isEmpty
        if areCellsPreselected
        {
            navigationItem.rightBarButtonItem!.isEnabled = navigationItem.rightBarButtonItem!.isEnabled && selectedGenres.sorted() != alreadySelectedGenres!.sorted()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath)
    {
        selectedGenres.remove(at: selectedGenres.firstIndex(of: availableGenres[indexPath.section][indexPath.item])!)
        print(selectedGenres)
        navigationItem.rightBarButtonItem!.isEnabled = !selectedGenres.isEmpty
        if areCellsPreselected
        {
            navigationItem.rightBarButtonItem!.isEnabled = navigationItem.rightBarButtonItem!.isEnabled && selectedGenres.sorted() != alreadySelectedGenres!.sorted()
        }
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
        self.delegate?.onGenreSelection(selectedGenres: selectedGenres)
    }
    
    @objc func onNextButtonTap(_ sender: UIBarButtonItem)
    {
        self.delegate?.onGenreSelection(selectedGenres: selectedGenres)
    }
}
