//
//  TrackDescCell.swift
//  AppStore_SearchDemo
//
//  Created by 태우 on 2020/09/10.
//  Copyright © 2020 taewoo. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class TrackDescCell: ExpandableTableViewCell {
    
    @IBOutlet weak var descTextView: UITextView! {
        didSet {
            descTextView.isScrollEnabled = false
            descTextView.isEditable = false
            descTextView.isSelectable = false
            descTextView.isUserInteractionEnabled = false
            descTextView.textContainer.lineFragmentPadding = 0
            descTextView.font = UIFont.preferredFont(for: .subheadline, weight: .regular)
            descTextView.textContainer.maximumNumberOfLines = 3
        }
    }
    
    @IBOutlet weak var devContainerView: UIView!
    
    @IBOutlet weak var artistLabel: UILabel!
    
    @IBOutlet weak var developmentLabel: UILabel!
    
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
    
    var disposeBag = DisposeBag()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        bind()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func bind() {
        let containerTapGesture = UITapGestureRecognizer()
        self.devContainerView.addGestureRecognizer(containerTapGesture)
        
        containerTapGesture.rx.event
            .subscribe(onNext: { _ in
                print("tap!!!!")
            })
        .disposed(by: disposeBag)
    }
    
    func setData() {
        guard let track = self.track else { return }
        
        descTextView.text = track.description
        artistLabel.text = track.artistName
    }
    
    private func expand () {
        descTextView.textContainer.maximumNumberOfLines = _isExpand ? 0 : 3
        viewMoreButton.isHidden = _isExpand
    }
    
    
}
