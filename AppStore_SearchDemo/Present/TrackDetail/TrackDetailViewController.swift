//
//  TrackDetailViewController.swift
//  AppStore_SearchDemo
//
//  Created by 태우 on 2020/09/10.
//  Copyright © 2020 taewoo. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift


class TrackDetailViewController: UIViewController {

    lazy var tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.delegate = self
        $0.dataSource = self
        $0.separatorStyle = .none
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = UITableView.automaticDimension
        $0.backgroundColor = .white
        
        for item in self.items {
            $0.register(UINib(nibName: item.cellIdentifier, bundle: nil), forCellReuseIdentifier: item.cellIdentifier)
        }
    }
    
    let track: Track?
    
    let presentViewModel = PresentViewModel()
    
    var disposeBag = DisposeBag()
    
    /// tableView의 섹션을 구성하는 리스트
    var items: [TrackDetailItem] = [
        .init(type: .title, cellIdentifier: "TrackTitleCell", isExpand: true),
        .init(type: .releaseNote, cellIdentifier: "ReleaseNoteCell", isExpand: false),
        .init(type: .preview, cellIdentifier: "PreviewCell", isExpand: true),
        .init(type: .description, cellIdentifier: "TrackDescCell", isExpand: false),
        .init(type: .info, cellIdentifier: "TrackInfoCell", isExpand: true)
    ]
    
    /// TrackDetailItem의 type 값이 .info인 섹션을 구성하는 리스트
    var infoItems: [TrackInfoItem] = [
        .init(type: .seller, isExpandable: false),
        .init(type: .appSize, isExpandable: false),
        .init(type: .category, isExpandable: true, isExpand: false),
        .init(type: .compatible, isExpandable: true, isExpand: false),
        .init(type: .lang, isExpandable: false),
        .init(type: .grade, isExpandable: true, isExpand: false),
        .init(type: .copyright, isExpandable: false),
        .init(type: .devWebSite, isExpandable: false),
        .init(type: .privacyPolicy, isExpandable: false)
    ]
    
    
    init(track: Track) {
        self.track = track
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
    }
    
    private func bind() {
        presentViewModel.state.presentViewResponse
            .subscribe(onNext: { [weak self] viewController in
                self?.present(viewController, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
}

extension TrackDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let item = items[section]
        
        switch item.type {
        case .info:
            return infoItems.count
            
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section]
        
        switch item.type {
        case .title:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrackTitleCell", for: indexPath) as! TrackTitleCell
            cell.track = self.track
            return cell
            
        case .releaseNote:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReleaseNoteCell", for: indexPath) as! ReleaseNoteCell
            cell.track = self.track
            cell.isExpand = item.isExpand
            return cell
            
        case .description:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrackDescCell", for: indexPath) as! TrackDescCell
            cell.track = self.track
            cell.isExpand = item.isExpand
            return cell
        
        case .preview:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PreviewCell", for: indexPath) as! PreviewCell
            cell.track = self.track
            cell.presentViewModel = self.presentViewModel
            return cell
            
        case .info:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrackInfoCell", for: indexPath) as! TrackInfoCell
            cell.infoItem = infoItems[indexPath.row]
            cell.track = self.track
            cell.separatorView.isHidden = indexPath.row >= infoItems.count - 1
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.section]
        
        switch item.type {
        case .releaseNote, .description:
            self.items[indexPath.section].isExpand = true
            tableView.reloadRows(at: [indexPath], with: .fade)
            
        case .info:
            let infoItem = infoItems[indexPath.row]
            switch infoItem.type {
            case .devWebSite:
                if let urlString = track?.artistViewUrl,
                    let url = URL(string: urlString) {
                    UIApplication.shared.open(url, options: [:])
                }
                
            default: break
            }
            
        default: break
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let item = items[section]
        return item.type.makeTableHeaderView(tableView: tableView)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 20))
        let separatorView = UIView().then {
            $0.backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9098039216, alpha: 1)
        }
        
        footerView.addSubview(separatorView)
        separatorView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        return footerView
    }
    
    
}
