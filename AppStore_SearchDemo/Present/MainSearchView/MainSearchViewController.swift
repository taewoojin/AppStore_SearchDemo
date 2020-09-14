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


class MainSearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var searchController: UISearchController!
    
    var searchTableViewController: SearchTableViewController!
    
    var searchResultVC: SearchResultViewController?
    
    var disposeBag = DisposeBag()
    
    let viewModel = TrackViewModel()
    
    var recentQueries = [String]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let recentQuery = PlistManager.shared.readProperty(with: "recentQuery") as? [String] {
            self.recentQueries = recentQuery.reversedElement
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        searchTableViewController = storyboard!.instantiateViewController(withIdentifier: "SearchTableViewController") as? SearchTableViewController
        searchTableViewController.viewModel = self.viewModel
        
        searchController = UISearchController(searchResultsController: searchTableViewController)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "App Store"
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.searchTextField.textColor = .black
        searchController.searchBar.searchTextField.tokenBackgroundColor = .systemYellow

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.titleView?.isHidden = true
        
        let titleItem = UIBarButtonItem(title: "검색", style: .plain, target: nil, action: nil)
        titleItem.tintColor = .black
        titleItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 30, weight: .bold)], for: .normal)
        navigationItem.leftBarButtonItem = titleItem
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.clear]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        registerForKeyboardNotifications(scrollView: tableView, disposeBag: disposeBag)
        initSearchResultViewController()
        bind()
    }

    private func bind() {
        viewModel.state.selectedQueryResponse
            .subscribe(onNext: { [weak self] query in
                self?.searchController.searchBar.text = query
                self?.searchController.searchBar.endEditing(true)
            })
            .disposed(by: disposeBag)
    }
    
    private func initSearchResultViewController() {
        searchResultVC = SearchResultViewController(viewModel: self.viewModel)
                
        addChild(searchResultVC!)
        searchResultVC?.didMove(toParent: self)
        
        view.addSubview(searchResultVC!.view)
        searchResultVC!.view.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        searchResultVC?.view.isHidden = true
    }
    
    func searchResult(_ searchText: String?) {
        searchController.showsSearchResultsController = false
        searchResultVC?.view.isHidden = false
        searchResultVC?.searchText = searchText
    }
}


extension MainSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentQueries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LatestHistoryCell") as! LatestHistoryCell
        cell.query = recentQueries[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return createHeader(title: "최근 검색어")
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let query = recentQueries[indexPath.row]
        
        searchController.isActive = true
        searchController.searchBar.text = query
//        searchController.searchBar.endEditing(true)
        searchResult(query)
    }
    
    private func createHeader(title: String) -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 80))
        
        let titleLabel = UILabel().then {
            $0.text = title
            $0.font = UIFont.preferredFont(for: .title2, weight: .bold)
        }
        
        headerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(19)
        }
        
        return headerView
    }
    
}


extension MainSearchViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.searchBar.searchTextField.backgroundColor = nil
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.recentQueries = PlistManager.shared.appendQuery(key: PlistKey.recentQuery, query: searchBar.text!).reversedElement
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        /// searchText 변경이 생길때
        searchController.showsSearchResultsController = true
        searchResultVC?.view.isHidden = true
        searchResultVC?.tracks = []
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        if !(searchBar.text!.isEmpty) {
            searchResult(searchBar.text)
        }
        
        return true
    }
}

extension MainSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        if searchController.searchBar.text!.isEmpty {
            searchController.showsSearchResultsController = false
            searchResultVC?.view.isHidden = true
            searchResultVC?.tracks = []
        } else {
            searchController.showsSearchResultsController = true
            searchResultVC?.view.isHidden = false
        }

        searchFor(searchController.searchBar.text)
    }
    
    func searchFor(_ searchText: String?) {
        guard searchController.isActive else { return }
        
        guard let searchText = searchText else {
            searchTableViewController.filteredQueries = []
            return
        }
        
        let filteredQueries = recentQueries.filter { $0.contains(searchText) }
        
        searchTableViewController.filteredQueries = filteredQueries
    }
}
