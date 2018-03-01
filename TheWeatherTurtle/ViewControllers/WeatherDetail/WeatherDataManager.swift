//
//  WeatherViewDataSource.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 07/02/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

import Foundation
import UIKit

final class WeatherDataManager {
    private let weatherService: WeatherService
    private let dataStoreService: DataStoreService
    
    init(weatherService: WeatherService, dataStoreService: DataStoreService) {
        self.weatherService = weatherService
        self.dataStoreService = dataStoreService
    }
    
    func getWeatherDetails(cityID: String, completion: @escaping (ViewState<WeatherViewModel>) -> ()) {
        weatherService.getWeatherDetails(cityID: cityID) { (response) in
            switch response {
            case .error(_):
                completion(.error)
                
            case .success(let data):
                let viewModel = WeatherViewModel(with: data) ?? WeatherViewModel.empty()
                completion(.data(viewModel: viewModel))
            }
        }
    }
    
    func getWeatherDetails(cityIDs: [String], completion: @escaping (ViewState<WeatherListViewModel>) -> ()) {
        weatherService.getWeatherDetails(cityIDs: cityIDs) { (response) in
            switch response {
            case .error(_):
                completion(.error)
                
            case .success(let data):
                let viewModel = WeatherListViewModel(with: data) ?? WeatherListViewModel.empty()
                completion(.data(viewModel: viewModel))
            }
        }
    }

    func getWeatherDetails(latitude: Double, longitude: Double, completion: @escaping (ViewState<WeatherViewModel>) -> ()) {
        weatherService.getWeatherDetails(latitude: latitude, longitude: longitude) { (response) in
            switch response {
            case .error(_):
                completion(.error)

            case .success(let data):
                let viewModel = WeatherViewModel(with: data) ?? WeatherViewModel.empty()
                completion(.data(viewModel: viewModel))
            }
        }
    }

    func getAllCities(completion: @escaping (ViewState<AddCityViewModel>) -> Void) {
        dataStoreService.getAllCities { cities in
            let viewModel = cities.isEmpty ? AddCityViewModel.empty() : AddCityViewModel(allCities: cities)
            completion(.data(viewModel: viewModel))
        }
    }

    func getUserCities() -> [String] {
        return dataStoreService.getUserCities()
    }

    func storeCity(_ cityID: String) -> Bool {
        return dataStoreService.storeCity(cityID)
    }
    
    func removeCity(_ cityID: String) -> Bool {
        return dataStoreService.removeCity(cityID)
    }
}
