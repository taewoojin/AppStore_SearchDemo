//
//  PresentViewModel.swift
//  AppStore_SearchDemo
//
//  Created by 태우 on 2020/09/13.
//  Copyright © 2020 taewoo. All rights reserved.
//


import Foundation
import RxCocoa
import RxSwift

struct PresentViewModel {
    
    struct Action {
        let pushViewController = PublishRelay<UIViewController>()
        let presentViewController = PublishRelay<UIViewController>()
    }
    
    struct State {
        let pushViewResponse = PublishRelay<UIViewController>()
        let presentViewResponse = PublishRelay<UIViewController>()
    }
    
    let action = Action()
    
    let state = State()
    
    var disposeBag = DisposeBag()
    
    init() {
        
        action.pushViewController
            .bind(to: state.pushViewResponse)
            .disposed(by: disposeBag)
        
        action.presentViewController
            .bind(to: state.presentViewResponse)
            .disposed(by: disposeBag)
    }
}
