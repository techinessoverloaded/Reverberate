//
//  SearchViewController.swift
//  Reverberate
//
//  Created by arun-13930 on 07/07/22.
//

import UIKit

class SearchViewController: UITableViewController
{
    private let browseLabel: UILabel = {
        let bLabel = UILabel(useAutoLayout: true)
        bLabel.textColor = .label
        bLabel.font = .systemFont(ofSize: 26, weight: .bold)
        bLabel.text = "Browse All"
        return bLabel
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "Artists, Songs, Albums"
        self.navigationItem.searchController = searchController
    }

}

//TableView Delegate and Datasource
extension SearchViewController
{
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        1
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .clear
        return cell
    }
}
