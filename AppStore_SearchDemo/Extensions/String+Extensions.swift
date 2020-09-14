//
//  String+Extensions.swift
//  AppStore_SearchDemo
//
//  Created by 태우 on 2020/09/13.
//  Copyright © 2020 taewoo. All rights reserved.
//

import Foundation

extension String {
    var condenseWhitespaceToPlus: String {
        let components = self.components(separatedBy: .whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: "+")
    }
}
