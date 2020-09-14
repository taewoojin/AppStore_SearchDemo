//
//  TrackTitleCell.swift
//  AppStore_SearchDemo
//
//  Created by 태우 on 2020/09/10.
//  Copyright © 2020 taewoo. All rights reserved.
//

import UIKit
import Cosmos

class TrackTitleCell: ExpandableTableViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView! {
        didSet {
            thumbnailImageView.layer.cornerRadius = 10
            thumbnailImageView.layer.borderWidth = 1
            thumbnailImageView.layer.borderColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
            thumbnailImageView.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.preferredFont(for: .title2, weight: .semibold)
        }
    }
    
    @IBOutlet weak var sellerLabel: UILabel! {
        didSet {
            sellerLabel.font = UIFont.preferredFont(for: .subheadline, weight: .regular)
        }
    }
    
    @IBOutlet weak var downloadButton: UIButton! {
        didSet {
            downloadButton.setTitleColor(.white, for: .normal)
            downloadButton.backgroundColor = .systemBlue
            downloadButton.layer.cornerRadius = 13
        }
    }
    
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var contentAdvisoryRatingLabel: UILabel!
    
    @IBOutlet weak var appCategoryLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var ratingStarView: CosmosView!
    
    var track: Track? {
        didSet {
            setData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    private func setData() {
        guard let track = self.track else { return }
        
        thumbnailImageView.cacheImage(urlString: track.artworkUrl512)
        titleLabel.text = track.trackName
        
        sellerLabel.text = track.sellerName
        
        contentAdvisoryRatingLabel.text = track.contentAdvisoryRating
        
        ratingStarView.rating = track.averageUserRatingForCurrentVersion
        ratingLabel.text = "\(track.userRatingCountForCurrentVersion)"
        
        appCategoryLabel.text = track.genres.first
    }
}
