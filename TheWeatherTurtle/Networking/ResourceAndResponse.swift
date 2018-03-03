//
//  ResourceAndResponse.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 03/03/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

import Foundation

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
                
            } else if let data = data as? A {
                return data
                
            } else {
                return nil
            }
            
        }
    }
}
