//
//  WeatherService.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 07/02/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

import Foundation
import UIKit

final class WeatherService {
    
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func getWeatherDetails(city: String, completion: @escaping (Response<WeatherDetails>) -> ()) {
        let cityWeatherDetails = Resource<WeatherDetails>(url: weatherURL(for: city))
        networkManager.load(resource: cityWeatherDetails) { response in
            completion(response)
        }
    }
    
    func getWeatherDetails(cities: [String], completion: @escaping (Response<WeatherDetailsList>) -> ()) {
        let cityWeatherDetails = Resource<WeatherDetailsList>(url: weatherURL(for: cities))
        networkManager.load(resource: cityWeatherDetails) { response in
            completion(response)
        }
    }
}

extension WeatherService {
    private func weatherURL(for city: String) -> URL {
        guard let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(networkManager.openWeatherMapKey)") else {
            fatalError("\(#file): \(#function)")
        }
        return url
    }
    
    private func weatherURL(for cities: [String]) -> URL {
        var cityIDs = cities.first ?? ""
        for cityID in cities.dropFirst() {
            cityIDs = "\(cityIDs),\(cityID)"
        }
        guard let url = URL(string: "http://api.openweathermap.org/data/2.5/group?id=\(cityIDs)&units=metric&appid=\(networkManager.openWeatherMapKey)") else {
            fatalError("\(#file): \(#function)")
        }
        return url
    }
}
