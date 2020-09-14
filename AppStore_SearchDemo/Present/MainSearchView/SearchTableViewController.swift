//
//  SearchTableViewController.swift
//  AppStore_SearchDemo
//
//  Created by 태우 on 2020/09/08.
//  Copyright © 2020 taewoo. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {

    var filteredQueries = [String]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var viewModel: TrackViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredQueries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTermCell", for: indexPath) as? SearchTermCell else {
            return UITableViewCell()
        }

        cell.query = filteredQueries[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedQuery = filteredQueries[indexPath.row]
        viewModel?.action.selectSearchingQuery.accept(selectedQuery)
    }
    

}
