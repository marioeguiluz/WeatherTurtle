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
    
    func getWeatherIcon(code: String, completion: @escaping (Response<Data>) -> ()) {
        let imageData = Resource<Data>(url: weatherIconURL(for: code))
        networkManager.load(resource: imageData) { response in
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
    
    private func weatherIconURL(for code: String) -> URL {
        guard let url = URL(string: "http://openweathermap.org/img/w/\(code).png") else {
            fatalError("\(#file): \(#function)")
        }
        return url
    }
}
