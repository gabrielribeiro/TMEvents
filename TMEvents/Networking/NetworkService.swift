//
//  NetworkService.swift
//  TMEvents
//
//  Created by Gabriel Ribeiro on 08/11/23.
//

import Foundation

protocol NetworkService {
    func request<T: Codable>(_ type: T.Type, url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void)
}

class TMNetworkService: NetworkService {
    func request<T: Codable>(_ type: T.Type, url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }
            
            do {
                let decodedObject = try newJSONDecoder().decode(type, from: data)
                completionHandler(decodedObject, response, nil)
            } catch {
                completionHandler(nil, response, error)
            }
        }
        
        task.resume()
    }
}

fileprivate func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}
