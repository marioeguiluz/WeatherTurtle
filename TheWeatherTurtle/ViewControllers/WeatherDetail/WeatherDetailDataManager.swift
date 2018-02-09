//
//  WeatherViewDataSource.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 07/02/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

final class WeatherDetailDataManager {
    let weatherService: WeatherService
    
    init(weatherService: WeatherService) {
        self.weatherService = weatherService
    }
    
    func getWeatherDetails(city: String, completion: @escaping (WeatherViewState) -> ()) {
        weatherService.getWeatherDetails(city: city) { (response) in
            switch response {
            case .error(_):
                completion(.error)
            case .success(let data):
                let viewModel = self.dataViewModel(with: data)
                completion(.data(viewModel: viewModel))
            }
        }
        completion(.loading)
    }
    
    private func dataViewModel(with data: WeatherDetails?) -> WeatherViewModel {
        guard let data = data else { return WeatherViewModel.empty() }
        return WeatherViewModel(city: data.name ?? "Noname", temperature: data.main?.temp ?? 0, detail: data.weather?.first?.description ?? "")
    }
}
