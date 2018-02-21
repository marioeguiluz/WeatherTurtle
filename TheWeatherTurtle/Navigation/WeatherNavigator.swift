//
//  WeatherListNavigator.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 10/02/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

import UIKit

protocol WeatherNavigable: Navigable {
    func pushWeatherDetail(city: String, on rootController: UINavigationController?)
    func pushAddCityWeather(on rootController: UINavigationController?)
}

final class WeatherNavigator: WeatherNavigable {
    private let routerManager: RouterManager
    
    init(routerManager: RouterManager) {
        self.routerManager = routerManager
    }
    
    func pushWeatherDetail(city: String, on rootController: UINavigationController?) {
        let detailVC = routerManager.instantiateWeatherDetailController(city: city)
        rootController?.pushViewController(detailVC, animated: true)
    }
    
    func pushAddCityWeather(on rootController: UINavigationController?) {
        let addVC = routerManager.instantiateAddCityController()
        rootController?.pushViewController(addVC, animated: true)
    }
}
