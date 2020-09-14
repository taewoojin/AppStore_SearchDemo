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
//    static func getData(resource: String) {
//        // 세션 생성, 환경설정
//        let defaultSession = URLSession(configuration: .default)
//
//        guard let url = URL(string: "\(resource)") else {
//            print("URL is nil")
//            return
//        }
//
//        // Request
//        let request = URLRequest(url: url)
//
//        // dataTask
//        let dataTask = defaultSession.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
//            // getting Data Error
//            guard error == nil else {
//                print("Error occur: \(String(describing: error))")
//                return
//            }
//
//            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//                return
//            }
//
//            // 통신에 성공한 경우 data에 Data 객체가 전달됩니다.
//
//            // 받아오는 데이터가 json 형태일 경우,
//            // json을 serialize하여 json 데이터를 swift 데이터 타입으로 변환
//            // json serialize란 json 데이터를 String 형태로 변환하여 Swift에서 사용할 수 있도록 하는 것을 말합니다.
//            guard let jsonToArray = try? JSONSerialization.jsonObject(with: data, options: []) else {
//                print("json to Any Error")
//                return
//            }
//            // 원하는 작업
//            print(jsonToArray)
//        }
//        dataTask.resume()
//    }
//
//    static func fetchData(urlString: String, parameters: [String:String], completeHandler: @escaping () -> ()) {
//        guard var urlComponent = URLComponents(string: urlString) else { return }
//
//        let session = URLSession(configuration: .default)
//        var items = [URLQueryItem]()
//
//        for (key, value) in parameters {
//            items.append(URLQueryItem(name: key, value: value))
//        }
//
//        urlComponent.queryItems = items
//        let request =  URLRequest(url: urlComponent.url!)
//
//        let datatask = session.dataTask(with: request, completionHandler: { data, response, error in
//            guard error == nil else {
////                debugPrint(error!)
//                #if DEBUG
//                fatalError("Catch Error: \(error)")
//                #else
//                    throw DecodingError
//                #endif
//                return
//            }
//
//            guard let jsonResponse = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any],
//                let jsonResult = jsonResponse["results"] as? [Any],
//                let resultData = try? JSONSerialization.data(withJSONObject: jsonResult, options: []) else {
//                return
//            }
//
//
//            let decoder = JSONDecoder()
//            let resultTrack = try? decoder.decode([Track].self, from: resultData)
//
//
//            let testTrack = try? decoder.decode(ResultTrack.self, from: data!)
//            print(testTrack)
//        })
//        datatask.resume()
//    }
    
    static func fetchData<T:Decodable>(model: T.Type, urlString: String, parameters: [String:String]) -> Observable<T> {
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
                    fatalError("Catch Error: \(error)")
                    #else
                    throw DecodingError
                    #endif
                }
                
                guard let jsonResponse = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any],
                    let jsonResult = jsonResponse["results"] as? [Any],
                    let resultData = try? JSONSerialization.data(withJSONObject: jsonResult, options: []) else {
                        return
                }
                
                let decoder = JSONDecoder()
//                let resultTrack = try? decoder.decode([Track].self, from: resultData)
                
                let resultTrack = try? decoder.decode(T.self, from: data!)
                observer.onNext(resultTrack!)
            })
            
            datatask.resume()
            
            return Disposables.create {
                datatask.cancel()
            }
        }
        
    }
    
}

