//
//  SearchViewController.swift
//  Reverberate
//
//  Created by arun-13930 on 07/07/22.
//

import UIKit
import PhotosUI

class SearchViewController: UITableViewController
{
    private lazy var browseLabel: UILabel = {
        let bLabel = UILabel(useAutoLayout: true)
        bLabel.textColor = .label
        bLabel.font = .systemFont(ofSize: 26, weight: .bold)
        bLabel.text = "Browse All"
        return bLabel
    }()
    
    private lazy var collectionView: UICollectionView = {
        let cView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        return cView
    }()
    
    private lazy var categories: [[String]] = [["New Releases", "Top Charts"], ["Tamil", "Malayalam"], ["Hindi", "Telugu"], ["Kannada", "English"], ["Classical", "Melody"], ["Western", "Rock"], ["Folk"]]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        navigationController?.navigationBar.prefersLargeTitles = true
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "Artists, Songs, Albums"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.largeTitleDisplayMode = .always
        collectionView.register(SelectionCardCVCell.self, forCellWithReuseIdentifier: SelectionCardCVCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsSelection = false
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
    }
}
//TableView Delegate and Datasource
extension SearchViewController
{
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0
        {
            let cellHeight = ((tableView.frame.width / 2.3) - 1) / 2
            let margin: CGFloat = 20
            return CGFloat(categories.count) * (cellHeight + margin)
        }
        else
        {
            return .zero
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if section == 0
        {
            return browseLabel
        }
        else
        {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as! CustomTableViewCell
        cell.backgroundColor = .clear
        cell.addSubViewToContentView(collectionView)
        return cell
    }
}

extension SearchViewController: UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return categories[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let section = indexPath.section
        let item = indexPath.item
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectionCardCVCell.identifier, for: indexPath) as! SelectionCardCVCell
        return cell.configureCell(title: nil, centerText: categories[section][item], backgroundColor: UIColor.randomDarkColor())
    }
}

extension SearchViewController: UICollectionViewDelegate
{
    
}

extension SearchViewController: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let cellWidth = (tableView.frame.width / 2.3) - 1
        return .init(width: cellWidth, height: cellWidth / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return .init(top: 10, left: 0, bottom: 10, right: 0)
    }
}
