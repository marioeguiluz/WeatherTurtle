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
    let temperature: Double
    let detail: String
    
    static func empty() -> WeatherViewModel {
        return WeatherViewModel(city: "No city", temperature: 0, detail: "No details")
    }
}
