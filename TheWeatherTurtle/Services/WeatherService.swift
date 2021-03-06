//
//  WeatherService.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 07/02/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

import Foundation
import UIKit

protocol WeatherService {
    func getWeatherDetails(cityID: String, completion: @escaping (Response<WeatherDetails>) -> ())
    func getWeatherDetails(cityIDs: [String], completion: @escaping (Response<WeatherDetailsList>) -> ())
    func getWeatherDetails(latitude: Double, longitude: Double, completion: @escaping (Response<WeatherDetails>) -> ())
}

final class OpenWeatherService: WeatherService {

    private let baseURL = "http://api.openweathermap.org/data/2.5/"
    private let networkManager: NetworkLayer
    
    init(networkManager: NetworkLayer) {
        self.networkManager = networkManager
    }
    
    func getWeatherDetails(cityID: String, completion: @escaping (Response<WeatherDetails>) -> ()) {
        let cityWeatherDetails = Resource<WeatherDetails>(url: weatherURL(for: cityID))
        networkManager.loadInBackground(resource: cityWeatherDetails) { response in
            completion(response)
        }
    }
    
    func getWeatherDetails(cityIDs: [String], completion: @escaping (Response<WeatherDetailsList>) -> ()) {
        let cityWeatherDetails = Resource<WeatherDetailsList>(url: weatherURL(for: cityIDs))
        networkManager.loadInBackground(resource: cityWeatherDetails) { response in
            completion(response)
        }
    }

    func getWeatherDetails(latitude: Double, longitude: Double, completion: @escaping (Response<WeatherDetails>) -> ()) {
        let cityWeatherDetails = Resource<WeatherDetails>(url: weatherURL(latitude: latitude, longitude: longitude))
        networkManager.loadInBackground(resource: cityWeatherDetails) { response in
            completion(response)
        }
    }
}

extension OpenWeatherService {
    private var openWeatherMapKey: String {
        return "d62caae37d4c67c3c6d9871a3f00482f"
    }

    private func weatherURL(for cityID: String) -> URL {
        guard let url = URL(string: "\(baseURL)weather?id=\(cityID)&units=metric&appid=\(openWeatherMapKey)") else {
            fatalError("\(#file): \(#function)")
        }
        return url
    }

    private func weatherURL(for cities: [String]) -> URL {
        guard cities.count < 20 else {
            print("Open Weather Map only supports this call with less than 20 cities at a time")
            fatalError("\(#file): \(#function)")
        }
        var cityIDs = cities.first ?? ""
        for cityID in cities.dropFirst() {
            cityIDs = "\(cityIDs),\(cityID)"
        }
        guard let url = URL(string: "\(baseURL)group?id=\(cityIDs)&units=metric&appid=\(openWeatherMapKey)") else {
            fatalError("\(#file): \(#function)")
        }
        return url
    }

    private func weatherURL(latitude: Double, longitude: Double) -> URL {
        guard let url = URL(string: "\(baseURL)weather?lat=\(latitude)&lon=\(longitude)&units=metric&appid=\(openWeatherMapKey)") else {
            fatalError("\(#file): \(#function)")
        }
        return url
    }
}
