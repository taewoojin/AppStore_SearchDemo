//
//  TrackService.swift
//  AppStore_SearchDemo
//
//  Created by 태우 on 2020/09/09.
//  Copyright © 2020 taewoo. All rights reserved.
//

import RxCocoa
import RxSwift


protocol TrackServiceProtocol {
    func fetchTrack(searchText: String) -> Observable<ResultTrack>
}

class TrackService: TrackServiceProtocol {
    let repository: TrackRepositoryProtocol = TrackRepository()
    
    func fetchTrack(searchText: String) -> Observable<ResultTrack> {
        return repository.fetchTrack(searchText: searchText)
    }
}
