//
//  SearchResultCell.swift
//  AppStore_SearchDemo
//
//  Created by 태우 on 2020/09/10.
//  Copyright © 2020 taewoo. All rights reserved.
//

import UIKit
import Cosmos

class SearchResultCell: UITableViewCell {

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
            titleLabel.font = UIFont.preferredFont(for: .subheadline, weight: .medium)
        }
    }
    
    @IBOutlet weak var subTitleLabel: UILabel! {
        didSet {
            subTitleLabel.font = UIFont.preferredFont(for: .caption1, weight: .regular)
            subTitleLabel.textColor = .lightGray
        }
    }
    
    @IBOutlet weak var ratingStarView: CosmosView!
    
    @IBOutlet weak var downloadButton: UIButton! {
        didSet {
            downloadButton.layer.cornerRadius = 14
            downloadButton.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
        }
    }
    
    @IBOutlet weak var screenShotStackView: UIStackView!
    
    @IBOutlet weak var screenShotRatio: NSLayoutConstraint!
    
    
    var track: Track? {
        didSet {
            setData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    private func makeScreenShotImageView() -> UIImageView {
        return UIImageView().then {
            $0.backgroundColor = .lightGray
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
            $0.contentMode = .scaleAspectFit
            $0.autoresizesSubviews = true
        }
    }
    
    private func setData() {
        guard let track = self.track else { return }
        
        thumbnailImageView.cacheImage(urlString: track.artworkUrl100)
        titleLabel.text = track.trackName
        
        subTitleLabel.text = track.sellerName
        
        ratingStarView.rating = track.averageUserRatingForCurrentVersion ?? 0
        ratingStarView.text = "\(track.userRatingCountForCurrentVersion)"
        
        let screenShotSubviews = screenShotStackView.subviews.map { $0 as? UIImageView }
        for (index, imageView) in screenShotSubviews.enumerated() {
            if track.screenshotUrls.count >= index + 1 {
                let screenShotUrl = track.screenshotUrls[index]
                imageView?.cacheImage(urlString: screenShotUrl)
            }
        }
        
        
    }
    
}
