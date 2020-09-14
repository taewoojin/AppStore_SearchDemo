//
//  ReleaseNoteCell.swift
//  AppStore_SearchDemo
//
//  Created by 태우 on 2020/09/10.
//  Copyright © 2020 taewoo. All rights reserved.
//

import UIKit

class ReleaseNoteCell: ExpandableTableViewCell {

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.preferredFont(for: .title2, weight: .semibold)
        }
    }
    
    @IBOutlet weak var versionHistoryButton: UIButton! {
        didSet {
            versionHistoryButton.titleLabel?.font = UIFont.preferredFont(for: .headline, weight: .medium)
        }
    }
    
    @IBOutlet weak var versionLabel: UILabel! {
        didSet {
            versionLabel.font = UIFont.preferredFont(for: .subheadline, weight: .regular)
            versionLabel.textColor = .lightGray
        }
    }
    
    @IBOutlet weak var releaseDateLabel: UILabel! {
        didSet {
            releaseDateLabel.font = UIFont.preferredFont(for: .subheadline, weight: .regular)
            releaseDateLabel.textColor = .lightGray
        }
    }
    
    @IBOutlet weak var releaseNoteTextView: UITextView! {
        didSet {
            releaseNoteTextView.isScrollEnabled = false
            releaseNoteTextView.isEditable = false
            releaseNoteTextView.isSelectable = false
            releaseNoteTextView.isUserInteractionEnabled = false
            releaseNoteTextView.textContainer.lineFragmentPadding = 0
            releaseNoteTextView.font = UIFont.preferredFont(for: .subheadline, weight: .regular)
            releaseNoteTextView.textContainer.maximumNumberOfLines = 3
        }
    }
    
    @IBOutlet weak var viewMoreButton: UIButton! {
        didSet {
            viewMoreButton.isUserInteractionEnabled = false
        }
    }
    
    
    var track: Track? {
        didSet {
            setData()
        }
    }
    
    var _isExpand: Bool = false {
        didSet {
            expand()
        }
    }
    
    override var isExpand: Bool {
        get {
            return _isExpand
        }
        set {
            _isExpand = newValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func setData() {
        guard let track = self.track else { return }
        
        versionLabel.text = "버전 \(track.version)"
        releaseNoteTextView.text = track.releaseNotes
        
        if let releaseDate = Date.dateFromISOString(string: track.currentVersionReleaseDate) {
            let todayComponent = Calendar.current.dateComponents(
                [.calendar , .year, .month, .day, .hour, .minute, .second],
                from: Date()
            )

            let releaseDateComponent = Calendar.current.dateComponents(
                [.calendar , .year, .month, .day, .hour, .minute, .second],
                from: releaseDate
            )

            let diffDateComponent = Calendar.current.dateComponents(
                [.calendar , .year, .month, .day, .hour, .minute, .second],
                from: todayComponent,
                to: releaseDateComponent
            )
            
            if diffDateComponent.year! < 0 {
                releaseDateLabel.text = "\(-diffDateComponent.year!)년 전"
            } else if diffDateComponent.month! < 0 {
                releaseDateLabel.text = "\(-diffDateComponent.month!)개월 전"
            } else if diffDateComponent.day! < 0 {
                releaseDateLabel.text = "\(-diffDateComponent.day!)일 전"
            } else if diffDateComponent.hour! < 0 {
                releaseDateLabel.text = "\(-diffDateComponent.month!)시간 전"
            } else if diffDateComponent.minute! < 0 {
                releaseDateLabel.text = "\(-diffDateComponent.month!)분 전"
            } else {
                releaseDateLabel.text = "\(-diffDateComponent.month!)초 전"
            }
        }
        
    }
    
    func expand () {
        self.releaseNoteTextView.textContainer.maximumNumberOfLines = _isExpand ? 0 : 3
        viewMoreButton.isHidden = _isExpand
    }

}
