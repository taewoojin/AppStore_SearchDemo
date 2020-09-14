//
//  ExpandableTableViewCell.swift
//  AppStore_SearchDemo
//
//  Created by 태우 on 2020/09/12.
//  Copyright © 2020 taewoo. All rights reserved.
//

import UIKit

//protocol ExpandableTableViewCellProtocol: class {
//    var isExpand: Bool { get set }     /// 확장된 상태 Flag. 확장이 필요없는 셀은 처음부터 True로 설정.
//}

class ExpandableTableViewCell: UITableViewCell {
    var isExpand: Bool = true
}
