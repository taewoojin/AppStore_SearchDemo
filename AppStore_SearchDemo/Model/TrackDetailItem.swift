//
//  TrackDetailItem.swift
//  AppStore_SearchDemo
//
//  Created by 태우 on 2020/09/14.
//  Copyright © 2020 taewoo. All rights reserved.
//

import UIKit


struct TrackDetailItem {
    var type: TrackDetailItemType
    var cellIdentifier: String
    var isExpand: Bool
}

enum TrackDetailItemType {
    case title
    case releaseNote
    case description
    case info
    case preview
    
    func makeTableHeaderView(tableView: UITableView) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        let titleLabel = UILabel().then {
            $0.font = UIFont.preferredFont(for: .title2, weight: .semibold)
        }
        
        headerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        switch self {
        case .preview:
            titleLabel.text = "미리보기"
            return headerView
            
        case .info:
            titleLabel.text = "정보"
            return headerView
            
        default: return nil
        }
    }
}


