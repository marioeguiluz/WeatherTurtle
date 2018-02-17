//
//  CoreService.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 10/02/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

final class CoreService {
    
    private let networkManager: NetworkManager
    static let openWeatherMapKey = "d62caae37d4c67c3c6d9871a3f00482f"
    
    let weatherService: WeatherService
    let dataStoreService: DataStoreService
    
    init() {
        networkManager = NetworkManager()
        weatherService = WeatherService(networkManager: networkManager)
        dataStoreService = DataStoreService()
    }
}
