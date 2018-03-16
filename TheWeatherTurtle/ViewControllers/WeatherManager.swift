//
//  WeatherViewDataSource.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 07/02/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

import Foundation
import UIKit

final class WeatherManager {
    private let weatherRepository: WeatherRepository
    private let dataStoreRepository: DataStoreRepository

    init(weatherRepository: WeatherRepository, dataStoreRepository: DataStoreRepository) {
        self.weatherRepository = weatherRepository
        self.dataStoreRepository = dataStoreRepository
    }
    
    func getWeatherDetails(cityID: String, completion: @escaping (ViewState<WeatherViewModel>) -> ()) {
        weatherRepository.getWeatherDetails(cityID: cityID) { result in
            switch result {
            case .busy:
                completion(.loading)
            case .error(_):
                completion(.error)
            case .fetched(let data):
                let viewModel = WeatherViewModel(with: data) ?? WeatherViewModel.empty()
                completion(.data(viewModel: viewModel))
            }
        }
    }
    
    func getWeatherDetails(cityIDs: [String], completion: @escaping (ViewState<WeatherListViewModel>) -> ()) {
        weatherRepository.getWeatherDetails(cityIDs: cityIDs) { result in
            switch result {
            case .busy:
                completion(.loading)
            case .error(_):
                completion(.error)
            case .fetched(let data):
                let viewModel = WeatherListViewModel(with: data) ?? WeatherListViewModel.empty()
                completion(.data(viewModel: viewModel))
            }
        }
    }

    func getWeatherDetails(latitude: Double, longitude: Double, storeCity: Bool, completion: @escaping (ViewState<WeatherViewModel>) -> ()) {
        weatherRepository.getWeatherDetails(latitude: latitude, longitude: longitude) { result in
            switch result {
            case .busy:
                completion(.loading)
            case .error(_):
                completion(.error)
            case .fetched(let data):
                let viewModel = WeatherViewModel(with: data) ?? WeatherViewModel.empty()
                if storeCity {
                    _ = self.storeCity(viewModel.id)
                }
                completion(.data(viewModel: viewModel))
            }
        }
    }

    func searchableCities(completion: @escaping (ViewState<AddCityViewModel>) -> Void) {
        dataStoreRepository.searchableCities { cities in
            let viewModel = cities.isEmpty ? AddCityViewModel.empty() : AddCityViewModel(allCities: cities)
            completion(.data(viewModel: viewModel))
        }
    }

    func userSelectedCities() -> [String] {
        return dataStoreRepository.userSelectedCities()
    }

    func storeCity(_ cityID: String) -> Bool {
        return dataStoreRepository.storeCity(cityID)
    }
    
    func removeCity(_ cityID: String) -> Bool {
        return dataStoreRepository.removeCity(cityID)
    }
}
