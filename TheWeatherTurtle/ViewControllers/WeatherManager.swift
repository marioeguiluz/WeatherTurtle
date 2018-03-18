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
    
    func getWeatherDetailsRaw(cityID: String, completion: @escaping (WeatherDetails) -> ()) {
        let responseFromNetwork = WeatherDetails.exampleData()
        completion(responseFromNetwork)
    }
    
    func getWeatherDetails(cityID: String, completion: @escaping (WeatherViewModel) -> ()) {
        let viewModel = WeatherViewModel(with: WeatherDetails.exampleData()) ?? WeatherViewModel.empty()
        completion(viewModel)
    }
}
