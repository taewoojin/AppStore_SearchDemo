//
//  UIImageView+Extensions.swift
//  AppStore_SearchDemo
//
//  Created by 태우 on 2020/09/10.
//  Copyright © 2020 taewoo. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func cacheImage(urlString: String?, defaultImage: UIImage? = nil, completeHandler: ((UIImage) -> Void)? = nil) {
        self.image = defaultImage
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            
            if let handler = completeHandler {
                handler(imageFromCache)
            }
            return
        }
        
        guard let urlString = urlString, let url = URL(string: urlString) else {
            return
        }
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            if let imageData = try? Data(contentsOf: url), let imageToCache = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    imageCache.setObject(imageToCache, forKey: urlString as AnyObject)
                    self?.image = imageToCache
                    
                    if let handler = completeHandler {
                        handler(imageToCache)
                    }
                }
            }
        }
    }
    
}
