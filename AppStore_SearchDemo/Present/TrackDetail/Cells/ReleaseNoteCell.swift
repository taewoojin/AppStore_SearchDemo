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
            print("ReleaseNoteCell isExpand: \(newValue)")
            _isExpand = newValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//        print("ReleaseNoteCell setSelected: \(selected)")
    }
    
    func setData() {
        guard let track = self.track else { return }
        
        versionLabel.text = "버전 \(track.version)"
        
        let currentVersionReleaseDate = Date.dateFromISOString(string: track.currentVersionReleaseDate)!
        releaseDateLabel.text = Date.stringFromDate(date: currentVersionReleaseDate, formatString: "yyyy.MM.dd")
//        let currentDate = Calendar.current.dateComponents([.day, .weekday, .month, .year], from: Date())
//        let releaseDate = Calendar.current.dateComponents([.day, .weekday, .month, .year], from: currentVersionReleaseDate)
        
        releaseNoteTextView.text = track.releaseNotes
    }
    
    func expand () {
        self.releaseNoteTextView.textContainer.maximumNumberOfLines = _isExpand ? 0 : 3
        viewMoreButton.isHidden = _isExpand
            
//        self.setNeedsLayout()
//        self.layoutIfNeeded()
    }

}
