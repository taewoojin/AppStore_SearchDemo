//
//  PlistManager.swift
//  AppStore_SearchDemo
//
//  Created by 태우 on 2020/09/09.
//  Copyright © 2020 taewoo. All rights reserved.
//

import Foundation
import UIKit

enum PlistKey: String {
    case recentQuery = "recentQuery"
    case localHistory = "LocalHistory"
}

struct PlistManager {
    
    static var shared = PlistManager()
    
    var path: String {
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        path.append(contentsOf: "/\(PlistKey.localHistory.rawValue).plist")
        return path
    }
    
    func initLocalHistory() {
        if !FileManager.default.fileExists(atPath: path) {
            let bundle = Bundle.main.path(forResource: PlistKey.localHistory.rawValue, ofType: "plist")!
            try? FileManager.default.copyItem(atPath: bundle, toPath: path)
        }
    }
    
    func readProperty(with key: String) -> Any? {
        let dict = NSDictionary(contentsOfFile: path)
        return dict?[key]
    }
    
    func appendQuery(key: PlistKey, query: String) {
        guard var recentQuery = readProperty(with: key.rawValue) as? [String] else { return }
        
        guard !recentQuery.contains(query) else { return }
        
        recentQuery.append(query)

        let dict = NSMutableDictionary(contentsOfFile: path)
        dict?.setObject(recentQuery, forKey: key.rawValue as NSCopying)
        dict?.write(toFile: path, atomically: false)
    }
}
