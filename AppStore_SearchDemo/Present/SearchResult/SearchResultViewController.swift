//
//  SearchResultViewController.swift
//  AppStore_SearchDemo
//
//  Created by 태우 on 2020/09/10.
//  Copyright © 2020 taewoo. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SearchResultViewController: UIViewController {

    lazy var tableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.separatorStyle = .none
        $0.rowHeight = UITableView.automaticDimension
        $0.register(UINib(nibName: "SearchResultCell", bundle: nil), forCellReuseIdentifier: "SearchResultCell")
    }
    
    let indicatorView = UIActivityIndicatorView(style: .large).then {
        $0.hidesWhenStopped = true
    }
    
    lazy var resultEmptyStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = 12
        
        $0.addArrangedSubview(self.emptyMessageLabel)
        $0.addArrangedSubview(self.emptySearchingText)
    }
    
    let emptyMessageLabel = UILabel().then {
        $0.text = "결과 없음"
        $0.font = UIFont.preferredFont(for: .title1, weight: .bold)
    }
    
    let emptySearchingText = UILabel()
    
    let viewModel: TrackViewModel
    
    var disposeBag = DisposeBag()
    
    var tracks = [Track]() {
        didSet {
            resultEmptyStackView.isHidden = !tracks.isEmpty
            tableView.reloadData()
        }
    }
    
    var searchText: String? {
        didSet {
            guard let text = searchText else { return }
            emptySearchingText.text = "'\(text)'"
            viewModel.action.fetchTrack.accept(text)
        }
    }
    
    
    init(viewModel: TrackViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        layout()
        bind()
    }
    
    private func layout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(indicatorView)
        indicatorView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        view.addSubview(resultEmptyStackView)
        resultEmptyStackView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    private func bind() {
        viewModel.state.fetchedTrackResponse
            .observeOn(MainScheduler.instance)
            .do(onNext: { [weak self] _ in
                self?.indicatorView.stopAnimating()
            })
            .subscribe(onNext: { [weak self] result in
                self?.tracks = result?.results ?? []
            })
            .disposed(by: disposeBag)
        
        viewModel.state.isPlayingIndicator
            .observeOn(MainScheduler.instance)
            .bind(onNext: { [weak self] isPlay in
                if isPlay {
                    self?.indicatorView.startAnimating()
                } else {
                    self?.indicatorView.stopAnimating()
                }
                
                self?.resultEmptyStackView.isHidden = true
            })
            .disposed(by: disposeBag)
    }
    
}


extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as! SearchResultCell
        cell.track = tracks[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let trackDetailVC = TrackDetailViewController(track: self.tracks[indexPath.row])
        navigationController?.pushViewController(trackDetailVC, animated: true)
    }
    
}
