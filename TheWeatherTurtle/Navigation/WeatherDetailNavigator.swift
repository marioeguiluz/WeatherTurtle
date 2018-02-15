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
    
    init(routerManager: RouterManager ) {
        self.routerManager = routerManager
    }
}

protocol WeatherListNavigable: Navigable {
    func pushWeatherDetail(city: String)
}

final class WeatherListNavigator: WeatherListNavigable {
    private let routerManager: RouterManager
    
    init(routerManager: RouterManager) {
        self.routerManager = routerManager
    }
    
    func pushWeatherDetail(city: String) {
        let detailVC = routerManager.instantiateWeatherDetailController(city: city)
        routerManager.mainNavigationController?.pushViewController(detailVC, animated: true)
    }
}
