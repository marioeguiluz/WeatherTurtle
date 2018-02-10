//
//  WeatherViewModel.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 07/02/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

enum WeatherViewState {
    case loading
    case error
    case data(viewModel: WeatherViewModel)
    
    func isLoading() -> Bool {
        switch self {
        case .loading:
            return true
        default:
            return false
        }
    }
    
    func isError() -> Bool {
        switch self {
        case .error:
            return true
        default:
            return false
        }
    }
    
    func isData() -> Bool {
        switch self {
        case .data(_):
            return true
        default:
            return false
        }
    }
}

struct WeatherViewModel {
    let city: String
    let temperature: String
    let detail: String
}

extension WeatherViewModel {
    
    init?(with data: WeatherDetails?) {
        guard
            let cityName = data?.name,
            let temp = data?.main?.temp,
            let details = data?.weather?.first?.description else {
                return nil
        }
        city = cityName
        temperature = "\(temp)"
        detail = details
    }
    
    static func empty() -> WeatherViewModel {
        return WeatherViewModel(city: "No city", temperature: "No data", detail: "No details")
    }
}
