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
    
    func getWeatherDetails(city: String, completion: @escaping (ViewState<WeatherViewModel>) -> ()) {
        weatherService.getWeatherDetails(city: city) { (response) in
            switch response {
            case .error(_):
                completion(.error)
                
            case .success(let data):
                let viewModel = WeatherViewModel(with: data) ?? WeatherViewModel.empty()
                completion(.data(viewModel: viewModel))
            }
        }
    }
    
    func getWeatherDetails(cities: [String], completion: @escaping (ViewState<WeatherListViewModel>) -> ()) {
        weatherService.getWeatherDetails(cities: cities) { (response) in
            switch response {
            case .error(_):
                completion(.error)
                
            case .success(let data):
                let viewModel = WeatherListViewModel(with: data) ?? WeatherListViewModel.empty()
                completion(.data(viewModel: viewModel))
            }
        }
    }

    func getAllCities(completion: @escaping (ViewState<AddCityViewModel>) -> Void) {
        dataStoreService.getAllCities { cities in
            let viewModel = cities.isEmpty ? AddCityViewModel.empty() : AddCityViewModel(cityResults: cities)
            completion(.data(viewModel: viewModel))
        }
    }
}
