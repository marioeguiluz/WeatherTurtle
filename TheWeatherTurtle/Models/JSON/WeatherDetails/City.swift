//
//  City.swift
//  TheWeatherTurtle
//
//  Created by MARIO EGUILUZ ALEBICTO on 17/02/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

struct City: Codable {
    let id: Int?
    let name: String?
    let country: String?
}

extension City {
    init(with dictionary: Dictionary<String,Any>) {
        id = dictionary["id"] as? Int ?? nil
        name = dictionary["name"] as? String ?? nil
        country = dictionary["country"] as? String ?? nil
    }
}
