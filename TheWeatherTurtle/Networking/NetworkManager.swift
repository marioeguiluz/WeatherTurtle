//
//  NetworkManager.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 07/02/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

import Foundation

protocol NetworkLayer {
    func loadInBackground<A>(resource: Resource<A>, completion: @escaping (Response<A>) -> ())
}

final class NetworkManager: NetworkLayer {

    func loadInBackground<A>(resource: Resource<A>, completion: @escaping (Response<A>) -> ()) {
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
