//
//  ResourceAndResponse.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 03/03/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

import Foundation

struct Resource<T: Decodable> {
    let url: URL
    let parse: (Data) -> T?
}

enum Response<T: Decodable> {
    case error(info: Error)
    case success(data: T?)
}

extension Resource {
    init(url: URL) {
        self.url = url
        self.parse = { data in
            let decoder = JSONDecoder()
            return try? decoder.decode(T.self, from: data)
        }
    }
}
