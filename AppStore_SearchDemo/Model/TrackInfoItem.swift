//
//  TrackInfoItem.swift
//  AppStore_SearchDemo
//
//  Created by 태우 on 2020/09/14.
//  Copyright © 2020 taewoo. All rights reserved.
//


struct TrackInfoItem {
    var type: TrackInfoItemType
    var isExpandable: Bool
    var isExpand: Bool? = nil
}

enum TrackInfoItemType {
    case seller
    case appSize
    case category
    case compatible
    case lang
    case grade
    case copyright
    case devWebSite
    case privacyPolicy
    
    var title: String {
        switch self {
        case .seller: return "제공자"
        case .appSize: return "크기"
        case .category: return "카테고리"
        case .compatible: return "호환성"
        case .lang: return "언어"
        case .grade: return "연령 등급"
        case .copyright: return "저작권"
        case .devWebSite: return "개발자 웹 사이트"
        case .privacyPolicy: return "개인정보 처리방침"
        }
    }
    
    func fetchValue(from track: Track) -> String {
        switch self {
        case .seller: return track.sellerName
        case .appSize: return track.fileSizeBytes
        case .category: return track.genres.joined(separator: ", ")
        case .compatible: return "이 iPhone와(과) 호환"
        case .lang: return track.languageCodesISO2A.joined(separator: ", ")
        case .grade: return track.contentAdvisoryRating ?? ""
        case .copyright: return track.sellerName
        case .devWebSite: return "🧭"
        case .privacyPolicy: return "✋"
        }
    }
}


