//
//  NetworkManager.swift
//  AppStore_SearchDemo
//
//  Created by 태우 on 2020/09/08.
//  Copyright © 2020 taewoo. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift


struct NetworkManager {
    
    static func fetchData<T:Decodable>(model: T.Type, urlString: String, parameters: [String:String]) -> Observable<T?> {
        return Observable.create { observer in
            var urlComponent = URLComponents(string: urlString)!
            let session = URLSession(configuration: .default)
            var items = [URLQueryItem]()
            
            for (key, value) in parameters {
                items.append(URLQueryItem(name: key, value: value))
            }
            
            urlComponent.queryItems = items
            let request =  URLRequest(url: urlComponent.url!)
            
            let datatask = session.dataTask(with: request, completionHandler: { data, response, error in
                guard error == nil else {
                    #if DEBUG
                    fatalError("Catch Error: \(String(describing: error))")
                    #else
                    throw DecodingError
                    #endif
                }
                
                let decoder = JSONDecoder()
                let resultTrack = try? decoder.decode(T.self, from: data!)
                observer.onNext(resultTrack)
            })
            
            datatask.resume()
            
            return Disposables.create {
                datatask.cancel()
            }
        }
        
    }
    
}

