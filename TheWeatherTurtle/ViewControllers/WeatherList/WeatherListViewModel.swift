//
//  WeatherListViewModel.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 12/02/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

struct WeatherListViewModel {
    let cities: [WeatherViewModel]
}

extension WeatherListViewModel {
    
    init?(with data: WeatherDetailsList?) {
        guard let list = data?.list else { return nil }
        cities = list.flatMap { WeatherViewModel(with: $0) }
    }
    
    static func empty() -> WeatherListViewModel {
        return WeatherListViewModel(cities: [])
    }
}

