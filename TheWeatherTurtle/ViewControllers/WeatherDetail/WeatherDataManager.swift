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
    
    init(weatherService: WeatherService) {
        self.weatherService = weatherService
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
    
    func getWeatherIcon(code: String, completion: @escaping (UIImage?) -> ()) {
        weatherService.getWeatherIcon(code: code) { (response) in
            switch response {
            case .error(_):
                completion(nil)
            
            case .success(let data):
                guard let data = data else {
                    completion(nil)
                    return
                }
                
                let image = UIImage(data: data)
                completion(image)
            }
        }
    }
}
