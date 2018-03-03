//
//  CoreService.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 10/02/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

final class CoreService {
    
    private let networkManager: NetworkLayer
    
    let weatherService: WeatherService
    let dataStoreService: DataStoreService
    
    init() {
        networkManager = NetworkManager()
        weatherService = OpenWeatherService(networkManager: networkManager)
        dataStoreService = FileStoreage()
    }
}
