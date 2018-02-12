//
//  WeatherViewModel.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 07/02/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

struct WeatherViewModel {
    let city: String
    let temperature: String
    let detail: String
    let icon: String?
}

extension WeatherViewModel {
    
    init?(with data: WeatherDetails?) {
        guard
            let cityName = data?.name,
            let temp = data?.main?.temp,
            let details = data?.weather?.first?.description,
            let iconName = data?.weather?.first?.icon else {
                return nil
        }
        city = cityName
        temperature = "\(temp)"
        detail = details
        icon = iconName
    }
    
    static func empty() -> WeatherViewModel {
        return WeatherViewModel(city: "No city", temperature: "No data", detail: "No details", icon: nil)
    }
}
