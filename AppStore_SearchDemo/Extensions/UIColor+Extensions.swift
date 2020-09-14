//
//  UIColor+Extensions.swift
//  AppStore_SearchDemo
//
//  Created by 태우 on 2020/09/09.
//  Copyright © 2020 taewoo. All rights reserved.
//

import UIKit

extension UIColor {
    func as1ptImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 0.5), true, 0)
        let context = UIGraphicsGetCurrentContext()
        setFill()
        context?.fill(CGRect(x: 0, y: 0, width: 1, height: 0.5))
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return image
    }
}
