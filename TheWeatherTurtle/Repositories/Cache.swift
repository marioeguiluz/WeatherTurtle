//
//  Cache.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 16/03/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

import Foundation

final class Cache<Key: Hashable,Value> {
    var cache = Dictionary<Key, Value>()
    
    subscript(key: Key) -> Value? {
        get {
            return cache[key]
        }
        set {
            cache[key] = newValue
        }
    }
}
