//
//  Int+Extensions.swift
//  AppStore_SearchDemo
//
//  Created by 태우 on 2020/09/14.
//  Copyright © 2020 taewoo. All rights reserved.
//

import Foundation

extension Int {
    var convertedRating: String {
        let dividedBy10000 = Double(self) / 10000.0
        let dividedBy1000 = Double(self) / 1000.0
        
        if dividedBy10000 >= 1 {
            return  "\(String(format: "%.1f", dividedBy10000))만"
        } else if dividedBy1000 >= 1 {
            return "\(String(format: "%.1f", dividedBy1000))천"
        } else {
            return "\(self)"
        }
    }
}
