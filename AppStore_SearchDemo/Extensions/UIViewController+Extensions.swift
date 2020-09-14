//
//  UIViewController+Extensions.swift
//  AppStore_SearchDemo
//
//  Created by 태우 on 2020/09/08.
//  Copyright © 2020 taewoo. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

extension UIViewController {
    
    func registerForKeyboardNotifications(scrollView: UIScrollView, disposeBag: DisposeBag){
        NotificationCenter.default.rx
            .notification(UIResponder.keyboardDidShowNotification)
            .subscribe(onNext: { notification in
                let info = notification.userInfo!
                if let height = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size.height {
                    let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: height, right: 0.0)
                    scrollView.contentInset = contentInsets
                    scrollView.scrollIndicatorInsets = contentInsets
                }
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillHideNotification)
            .subscribe(onNext: { notification in
                let contentInsets = UIEdgeInsets.zero
                scrollView.contentInset = contentInsets
                scrollView.scrollIndicatorInsets = contentInsets
            })
            .disposed(by: disposeBag)
    }
}
