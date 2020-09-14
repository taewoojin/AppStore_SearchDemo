//
//  AppDelegate.swift
//  AppStore_SearchDemo
//
//  Created by 태우 on 2020/09/08.
//  Copyright © 2020 taewoo. All rights reserved.
//

import UIKit
import Then
import SnapKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        PlistManager.shared.initLocalHistory()
        
        applyAppearance()
        
        return true
    }
    
    private func applyAppearance() {
//        window?.backgroundColor = .white
//        UINavigationBar.appearance().barStyle = .default
//        UINavigationBar.appearance().isTranslucent = false
//        UINavigationBar.appearance().backgroundColor = .white
    }

}

