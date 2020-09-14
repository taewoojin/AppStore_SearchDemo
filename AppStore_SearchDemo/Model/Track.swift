//
//  Track.swift
//  AppStore_SearchDemo
//
//  Created by 태우 on 2020/09/08.
//  Copyright © 2020 taewoo. All rights reserved.
//

import Foundation

struct ResultTrack: Decodable {
    var resultCount: Int
    var results: [Track]?
    
}

struct Track: Decodable {
    var screenshotUrls: [String]
    var artworkUrl60: String
    var artworkUrl512: String
    var artworkUrl100: String
    var artistViewUrl: String
    var isGameCenterEnabled: Bool
    var kind: String?
    var currency: String?
    var trackCensoredName: String?
    var languageCodesISO2A: [String]
    var fileSizeBytes: String
    var sellerUrl: String?
    var contentAdvisoryRating: String?
    var averageUserRatingForCurrentVersion: Double?
    var userRatingCountForCurrentVersion: Int
    var averageUserRating: Double?
    var trackViewUrl: String?
    var trackContentRating: String?
    var trackId: Int64?
    var trackName: String?
    var isVppDeviceBasedLicensingEnabled: Bool?
    var releaseDate: String?
    var primaryGenreName: String?
    var minimumOsVersion: String?
    var genreIds: [String]?
    var formattedPrice: String?
    var currentVersionReleaseDate: String
    var releaseNotes: String?
    var primaryGenreId: Int
    var sellerName: String
    var version: String
    var wrapperType: String?
    var artistId: Int64?
    var artistName: String?
    var genres: [String]
    var price: Double?
    var description: String?
    var bundleId: String?
    var userRatingCount: Int?
    
}
