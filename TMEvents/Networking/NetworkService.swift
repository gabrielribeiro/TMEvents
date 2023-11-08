//
//  NetworkService.swift
//  TMEvents
//
//  Created by Gabriel Ribeiro on 08/11/23.
//

import Foundation

protocol NetworkService {
    func request<T: Codable>(_ type: T.Type, url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

class TMNetworkService: NetworkService {
    func request<T: Codable>(_ type: T.Type, url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }
            
            do {
                let decodedObject = try newJSONDecoder().decode(type, from: data)
                completionHandler(decodedObject, response, nil)
            } catch {
                debugPrint(response)
                
                completionHandler(nil, response, error)
            }
        }
        
        task.resume()
        
        return task
    }
}

fileprivate func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}
