//
//  WeatherRepository.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 16/03/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

import Foundation

protocol WeatherRepository {
    func getWeatherDetails(cityID: String, completion: @escaping (Result<WeatherDetails>) -> ())
    func getWeatherDetails(cityIDs: [String], completion: @escaping (Result<WeatherDetailsList>) -> ())
    func getWeatherDetails(latitude: Double, longitude: Double, completion: @escaping (Result<WeatherDetails>) -> ())
}

final class CachedWeatherRepository: WeatherRepository {
    
    private let weatherService: WeatherService

    private let cache: Cache<String, WeatherDetails>
    private let listCache: Cache<String, WeatherDetailsList>
    
    init(weatherService: WeatherService) {
        self.weatherService = weatherService
        cache = Cache<String, WeatherDetails>()
        listCache = Cache<String, WeatherDetailsList>()
    }
    
    func getWeatherDetails(cityID: String, completion: @escaping (Result<WeatherDetails>) -> ()) {
       
        let cacheKey = cityID
        if let cachedValue = cache[cacheKey] {
            completion(.fetched(data: cachedValue))
        } else {
            completion(.busy)
        }
        weatherService.getWeatherDetails(cityID: cityID) { response in
            switch response {
            case .error(let info):
                completion(.error(info: info))
                
            case .success(let data):
                self.cache[cacheKey] = data
                completion(.fetched(data: data))
            }
        }
    }
    
    func getWeatherDetails(cityIDs: [String], completion: @escaping (Result<WeatherDetailsList>) -> ()) {
       
        let cacheKey = cityIDs.joined(separator: "-")
        if let cachedValue = listCache[cacheKey] {
            completion(.fetched(data: cachedValue))
        } else {
            completion(.busy)
        }
        
        weatherService.getWeatherDetails(cityIDs: cityIDs) { response in
            switch response {
            case .error(let info):
                completion(.error(info: info))
                
            case .success(let data):
                self.listCache[cacheKey] = data
                completion(.fetched(data: data))
            }
        }
    }
    
    func getWeatherDetails(latitude: Double, longitude: Double, completion: @escaping (Result<WeatherDetails>) -> ()) {
        
        let cacheKey = "\(latitude)-\(longitude)"
        if let cachedValue = cache[cacheKey] {
            completion(.fetched(data: cachedValue))
        } else {
            completion(.busy)
        }
        
        weatherService.getWeatherDetails(latitude: latitude, longitude: longitude) { response in
            switch response {
            case .error(let info):
                completion(.error(info: info))
                
            case .success(let data):
                self.cache[cacheKey] = data
                completion(.fetched(data: data))
            }
        }
    }
}
