//
//  GenreSelectionCollectionViewController.swift
//  Reverberate
//
//  Created by arun-13930 on 08/07/22.
//

import UIKit

class GenreSelectionCollectionViewController: UICollectionViewController
{
    private let availableGenres: [[Int16]] = [[], [0, 1], [2, 3], [4]]
    
    private var selectedGenres: [Int16] = []
    
    private weak var doneButtonRef: UIButton?
    
    weak var delegate: GenreSelectionDelegate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.collectionView!.register(TitleButtonBarCollectionViewCell.self, forCellWithReuseIdentifier: TitleButtonBarCollectionViewCell.identifier)
        self.collectionView!.register(SelectionCardCVCell.self, forCellWithReuseIdentifier: SelectionCardCVCell.identifier)
        self.collectionView!.allowsMultipleSelection = true
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return availableGenres.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if section == 0
        {
            return 1
        }
        else
        {
            return availableGenres[section].count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let section = indexPath.section
        if section == 0
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleButtonBarCollectionViewCell.identifier, for: indexPath) as! TitleButtonBarCollectionViewCell
            doneButtonRef = cell.configureCell(title: "Select your Favourite Music Genres", leftButtonTitle: nil, buttonTarget: self, leftButtonAction: nil, rightButtonTitle: "done", rightButtonAction: #selector(onDoneButtonTap(_:))).rightButtonRef
            return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectionCardCVCell.identifier, for: indexPath) as! SelectionCardCVCell
            let genre = MusicGenre(rawValue: availableGenres[section][indexPath.item])
            return cell.configureCell(title: nil, centerText: genre!.description, backgroundColor: genre!.preferredBackgroundColor)
        }
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool
    {
        return indexPath.section != 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let cell = collectionView.cellForItem(at: indexPath) as! SelectionCardCVCell
        cell.setSelectionOverlayView(isCellSelected: true)
        selectedGenres.append(availableGenres[indexPath.section][indexPath.item])
        print(selectedGenres)
        doneButtonRef?.isEnabled = !selectedGenres.isEmpty
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath)
    {
        let cell = collectionView.cellForItem(at: indexPath) as! SelectionCardCVCell
        cell.setSelectionOverlayView(isCellSelected: false)
        selectedGenres.remove(at: selectedGenres.firstIndex(of: availableGenres[indexPath.section][indexPath.item])!)
        print(selectedGenres)
        doneButtonRef?.isEnabled = !selectedGenres.isEmpty
    }

}

extension GenreSelectionCollectionViewController: UICollectionViewDelegateFlowLayout
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
            let cellWidth = (view.frame.width / 2.5) - 1
            return .init(width: cellWidth, height: cellWidth / 1.2)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return .init(top: 10, left: 15, bottom: 10, right: 15)
    }
}

extension GenreSelectionCollectionViewController
{
    @objc func onDoneButtonTap(_ sender: UIButton)
    {
        self.delegate?.onGenreSelection(selectedGenres: self.selectedGenres)
    }
}
