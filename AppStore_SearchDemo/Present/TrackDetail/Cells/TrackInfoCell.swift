//
//  TrackInfoCell.swift
//  AppStore_SearchDemo
//
//  Created by 태우 on 2020/09/11.
//  Copyright © 2020 taewoo. All rights reserved.
//

import UIKit

class TrackInfoCell: ExpandableTableViewCell {
    
    @IBOutlet weak var separatorView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var valueLabel: UILabel!
    
    var infoItem: TrackInfoItem? {
        didSet {
            guard let item = infoItem else { return }
            titleLabel.text = item.type.title
        }
    }
    
    var track: Track? {
        didSet {
            guard let track = track else { return }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}
