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
            self.recentQueries = recentQuery.sorted().reversed()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
//        navigationController?.navigationBar.isTranslucent = false
        
//        tableView.separatorStyle = .none
//        tableView.tableHeaderView = createHeader(title: "최근 검색어")
//        tableView.tableFooterView = UIView(frame: .zero)
        
//        self.extendedLayoutIncludesOpaqueBars = true
//        self.edgesForExtendedLayout = .all
//        self.definesPresentationContext = true
        
        let titleItem = UIBarButtonItem(title: "검색", style: .plain, target: nil, action: nil)
        titleItem.tintColor = .black
        titleItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 30, weight: .bold)], for: .normal)
        navigationItem.leftBarButtonItem = titleItem
        
        searchTableViewController = storyboard!.instantiateViewController(withIdentifier: "SearchTableViewController") as? SearchTableViewController
        searchTableViewController.viewModel = self.viewModel
        
        searchController = UISearchController(searchResultsController: searchTableViewController)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "App Store"
//        searchController.searchBar.scopeButtonTitles = Year.allCases.map { $0.description }
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
//        searchController.automaticallyShowsScopeBar = false
        searchController.searchBar.searchTextField.textColor = .black
        searchController.searchBar.searchTextField.tokenBackgroundColor = .systemYellow
//        searchController.hidesNavigationBarDuringPresentation = false
//        searchController.delegate = self
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        registerForKeyboardNotifications(scrollView: tableView, disposeBag: disposeBag)
        initSearchResultViewController()
        bind()
    }

    private func bind() {
        
        viewModel.state.selectedQueryResponse
            .subscribe(onNext: { [weak self] query in
                self?.searchController.searchBar.text = query
                print("query: \(query)")
                self?.searchController.searchBar.endEditing(true)
//                self?.searchResult(query)
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
}


extension MainSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentQueries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LatestHistoryCell") as? LatestHistoryCell else {
            return UITableViewCell()
        }
        
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
        PlistManager.shared.appendQuery(key: PlistKey.recentQuery, query: searchBar.text!)
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        print("replacementText: \(text)")
        
        /// searchText 변경이 생길때
        searchController.showsSearchResultsController = true
        searchResultVC?.view.isHidden = true
        searchResultVC?.tracks = []
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        print("searchBarShouldEndEditing: \(searchBar.text)")
        
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
        
        print("updateSearchResult: \(searchController.searchBar.text!)")

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

extension MainSearchViewController {
    func searchResult(_ searchText: String?) {
        searchController.showsSearchResultsController = false
        searchResultVC?.view.isHidden = false
        
        searchResultVC?.searchText = searchText
        print("searchResult: \(searchText)")
    }
}


extension MainSearchViewController: UISearchControllerDelegate {
    
    func didPresentSearchController(_ searchController: UISearchController) {
        navigationController?.navigationBar.isTranslucent = true
    }
    
//    func willPresentSearchController(_ searchController: UISearchController) {
//        navigationController?.navigationBar.isTranslucent = true
//    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        navigationController?.navigationBar.isTranslucent = false
    }
}
