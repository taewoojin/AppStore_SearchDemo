//
//  ViewController.swift
//  AppStore_SearchDemo
//
//  Created by 태우 on 2020/09/08.
//  Copyright © 2020 taewoo. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift


enum LatestSearch: String, CaseIterable {
    case test1
    case test2
    case test3
}

class MainSearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var searchController: UISearchController!
    var searchTableViewController: SearchTableViewController!
    
    let dummy = LatestSearch.allCases
    
    var disposeBag = DisposeBag()
    
    let viewModel = TrackViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let titleItem = UIBarButtonItem(title: "검색", style: .plain, target: nil, action: nil)
        titleItem.tintColor = .black
        titleItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 30, weight: .bold)], for: .normal)
        navigationItem.leftBarButtonItem = titleItem
        
        searchTableViewController = storyboard!.instantiateViewController(withIdentifier: "SearchTableViewController") as? SearchTableViewController
        
        searchController = UISearchController(searchResultsController: searchTableViewController)
        navigationItem.searchController = searchController
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "App Store"
//        searchController.searchBar.scopeButtonTitles = Year.allCases.map { $0.description }
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.automaticallyShowsScopeBar = false
        searchController.searchBar.searchTextField.textColor = .black
        searchController.searchBar.searchTextField.tokenBackgroundColor = .systemYellow
        
        registerForKeyboardNotifications(scrollView: tableView, disposeBag: disposeBag)
        
        
//        let url = Constant.Domain.searchUrl
//        let parameters = [
//            "media": "software",
//            "term": "카카오뱅크",
//            "country": "kr"
//        ]
//        NetworkManager.fetchData(urlString: url, parameters: parameters) {
//            print("success fetchData!!")
//        }
        
        bind()
    }

    private func bind() {
        viewModel.action.fetchTrack.accept(())
        
        viewModel.state.fetchedTrackResponse
            .subscribe(onNext: { result in
                print("fetchedTrackResponse: \(result)")
            })
            .disposed(by: disposeBag)
    }

}


extension MainSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LatestHistoryCell") as? LatestHistoryCell else {
            return UITableViewCell()
        }
        
        
        return cell
    }
    
    
}


extension MainSearchViewController: UISearchBarDelegate {
    
}

extension MainSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
//        // 1
//        if searchController.searchBar.searchTextField.isFirstResponder {
//            searchController.showsSearchResultsController = true
//            // 2
//            searchController.searchBar.searchTextField.backgroundColor = UIColor.black.withAlphaComponent(0.1)
//        } else {
//            // 3
//            searchController.searchBar.searchTextField.backgroundColor = nil
//        }
    }
}
