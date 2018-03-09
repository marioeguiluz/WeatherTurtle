//
//  WeatherListNavigable.swift
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

extension WeatherNavigable {
    func pushWeatherDetail(city: String, on rootController: UINavigationController?) {
        let detailVC = appPresentationManager.instantiateWeatherDetailController(city: city)
        rootController?.pushViewController(detailVC, animated: true)
    }
    
    func pushAddCityWeather(on rootController: UINavigationController?) {
        let addVC = appPresentationManager.instantiateAddCityController()
        rootController?.pushViewController(addVC, animated: true)
    }
}

final class WeatherNavigator: WeatherNavigable {
    let appPresentationManager: AppPresentationManager
    
    init(appPresentationManager: AppPresentationManager) {
        self.appPresentationManager = appPresentationManager
    }
}
