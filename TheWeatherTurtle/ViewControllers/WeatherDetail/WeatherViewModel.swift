//
//  WeatherViewModel.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 07/02/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

import Foundation

struct WeatherViewModel {
    let city: String
    let temperature: String
    let detail: String
    let icon: URL?
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
        temperature = "\(temp) °C"
        detail = details
        icon = WeatherViewModel.weatherIconURL(for: iconName)
    }
    
    static func empty() -> WeatherViewModel {
        return WeatherViewModel(city: "No city", temperature: "No data", detail: "No details", icon: nil)
    }
    
    private static func weatherIconURL(for code: String) -> URL? {
        guard let url = URL(string: "http://openweathermap.org/img/w/\(code).png") else {
            return nil
        }
        return url
    }
}
