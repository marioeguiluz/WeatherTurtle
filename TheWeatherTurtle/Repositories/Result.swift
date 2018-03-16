//
//  FetchResult.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 16/03/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

enum Result<T> {
    case busy
    case error(info: Error)
    case fetched(data: T?)
}
