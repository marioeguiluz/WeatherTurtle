//
//  CoreService.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 10/02/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

final class CoreService {
    
    private let networkManager: NetworkManager
    
    let weatherService: WeatherService
    let dataStoreService: DataStoreService
    let locationService: LocationService
    
    init() {
        networkManager = NetworkManager()
        weatherService = WeatherService(networkManager: networkManager)
        dataStoreService = DataStoreService()
        locationService = LocationService()
    }
}
