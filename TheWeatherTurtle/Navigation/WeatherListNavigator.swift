//
//  WeatherDetailNavigator.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 10/02/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

import UIKit

protocol WeatherListNavigable: Navigable {
    func pushWeatherDetail(city: String, on rootController: UINavigationController?)
}

final class WeatherListNavigator: WeatherListNavigable {
    private let routerManager: RouterManager
    
    init(routerManager: RouterManager) {
        self.routerManager = routerManager
    }
    
    func pushWeatherDetail(city: String, on rootController: UINavigationController?) {
        let detailVC = routerManager.instantiateWeatherDetailController(city: city)
        rootController?.pushViewController(detailVC, animated: true)
    }
}
