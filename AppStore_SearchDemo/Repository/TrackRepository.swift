//
//  TrackRepository.swift
//  AppStore_SearchDemo
//
//  Created by 태우 on 2020/09/09.
//  Copyright © 2020 taewoo. All rights reserved.
//

import RxCocoa
import RxSwift


protocol TrackRepositoryProtocol {
    func fetchTrack(searchText: String) -> Observable<ResultTrack>
}

class TrackRepository: TrackRepositoryProtocol {
    func fetchTrack(searchText: String) -> Observable<ResultTrack> {
        return NetworkManager.fetchData(
            model: ResultTrack.self,
            urlString: Constant.Domain.searchUrl,
            parameters: [
                "media": "software",
                "term": searchText.condenseWhitespaceToPlus,
                "country": "kr",
                "limit": "10"
            ]
        )
    }
}
