//
//  WeatherService.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 07/02/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

import Foundation

final class WeatherService {
    
    let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func getWeatherDetails(city: String, completion: @escaping (Response<WeatherDetails>) -> ()) {
        let cityWeatherDetailsUrl = URL(string: "http://samples.openweathermap.org/data/2.5/weather?q=London,uk&appid=b6907d289e10d714a6e88b30761fae22")!
        let cityWeatherDetails = Resource<WeatherDetails>(url: cityWeatherDetailsUrl)
        networkManager.load(resource: cityWeatherDetails) { response in
            completion(response)
        }
    }
}
