//
//  WeatherViewDataSource.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 07/02/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

final class WeatherDetailDataManager {
    private let weatherService: WeatherService
    
    init(weatherService: WeatherService) {
        self.weatherService = weatherService
    }
    
    func getWeatherDetails(city: String, completion: @escaping (WeatherViewState) -> ()) {
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
}
