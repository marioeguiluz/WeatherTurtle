//
//  NetworkManager.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 07/02/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

import Foundation

typealias JSONDictionary = [String: AnyObject]

struct Resource<A: Decodable> {
    let url: URL
    let parse: (Data) -> A?
}

enum Response<A: Decodable> {
    case error(info: Error)
    case success(data: A?)
}

extension Resource {
    
    init(url: URL) {
        self.url = url
        self.parse = { data in
            let decoder = JSONDecoder()
            if let model = try? decoder.decode(A.self, from: data) {
                return model
            } else {
                return nil
            }
        }
    }
}

final class NetworkManager {
    
    let openWeatherMapKey = "d62caae37d4c67c3c6d9871a3f00482f"
    
    func load<A>(resource: Resource<A>, completion: @escaping (Response<A>) -> ()) {
        URLSession.shared.dataTask(with: resource.url) { (data, response, error) in
            if let error = error {
                completion(.error(info: NSError(domain: "Error", code: 400, userInfo: ["reason": error.localizedDescription as Any])))
                return
            }
            
            guard let data = data else {
                completion(.error(info: NSError(domain: "Error", code: 400, userInfo: ["reason": "No data"])))
                return
            }
            
            completion(.success(data: resource.parse(data)))
            
            }.resume()
    }

}
