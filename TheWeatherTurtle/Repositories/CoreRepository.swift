//
//  CoreService.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 10/02/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

final class CoreRepository {
    
    let weatherRepository: WeatherRepository
    let dataStoreRepository: DataStoreRepository
    
    init() {
        let weatherService = OpenWeatherService(networkManager: NetworkManager())
        
        weatherRepository = CachedWeatherRepository(weatherService: weatherService)
        dataStoreRepository = FileStorage()
    }
}
