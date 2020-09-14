//
//  TrackViewModel.swift
//  AppStore_SearchDemo
//
//  Created by 태우 on 2020/09/09.
//  Copyright © 2020 taewoo. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift


struct TrackViewModel {
    
    struct Action {
        let fetchTrack = PublishRelay<String>()
        let selectSearchingQuery = PublishRelay<String>()
    }
    
    struct State {
        let fetchedTrackResponse = PublishRelay<ResultTrack>()
        let selectedQueryResponse = PublishRelay<String>()
        let isPlayingIndicator = BehaviorRelay<Bool>(value: false)
    }
    
    let action = Action()
    
    let state = State()
    
    let service: TrackServiceProtocol = TrackService()
    
    var disposeBag = DisposeBag()
    
    init() {
        
        let sharedFetchTrack = action.fetchTrack.share()
        
        sharedFetchTrack
            .flatMapLatest(service.fetchTrack)
            .bind(to: state.fetchedTrackResponse)
            .disposed(by: disposeBag)
        
        sharedFetchTrack
            .map { _ in return true }
            .bind(to: state.isPlayingIndicator)
            .disposed(by: disposeBag)
        
        action.selectSearchingQuery
            .bind(to: state.selectedQueryResponse)
            .disposed(by: disposeBag)
        
    }
}
