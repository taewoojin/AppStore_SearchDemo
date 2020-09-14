//
//  Array+Extensions.swift
//  AppStore_SearchDemo
//
//  Created by 태우 on 2020/09/14.
//  Copyright © 2020 taewoo. All rights reserved.
//

import Foundation

extension Array {
    var reversedElement: [Element] {
        var reversedQueries = [Element]()
        for index in stride(from: self.count - 1, to: 0, by: -1) {
            reversedQueries.append(self[index])
        }
        return reversedQueries
    }
}
