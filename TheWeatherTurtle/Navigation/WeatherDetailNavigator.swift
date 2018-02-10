//
//  WeatherDetailNavigator.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 10/02/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

protocol WeatherDetailNavigable: Navigable { }

final class WeatherDetailNavigator: WeatherDetailNavigable {
    private let routerManager: RouterManager
    private let weatherViewController: WeatherViewController
    
    init(routerManager: RouterManager, weatherViewController: WeatherViewController) {
        self.routerManager = routerManager
        self.weatherViewController = weatherViewController
    }
}
