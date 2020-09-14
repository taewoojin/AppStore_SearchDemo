//
//  ScreenshotCell.swift
//  AppStore_SearchDemo
//
//  Created by 태우 on 2020/09/13.
//  Copyright © 2020 taewoo. All rights reserved.
//

import UIKit


class ScreenshotCell: UICollectionViewCell {
    let screenshotImageView = UIImageView().then {
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }
    
    var imageUrl: String? {
        didSet {
            screenshotImageView.cacheImage(urlString: imageUrl)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layout()
    }
    
    private func layout() {
        addSubview(screenshotImageView)
        screenshotImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}
