//
//  AddCityNavigator.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 16/02/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

protocol AddCityNavigable: Navigable { }

final class AddCityNavigator: AddCityNavigable {
    private let routerManager: RouterManager
    
    init(routerManager: RouterManager) {
        self.routerManager = routerManager
    }
}
