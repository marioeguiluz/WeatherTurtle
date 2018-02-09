//
//  RouterManager.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 09/02/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

import UIKit

final class RouterManager {
    
    private weak var window: UIWindow?
    private let networkManager: NetworkManager
    private let weatherService: WeatherService
    
    init(window: UIWindow?) {
        self.window = window
        networkManager = NetworkManager()
        weatherService = WeatherService(networkManager: networkManager)
    }
    
    private func loadViewController<A: UIViewController>(type: A.Type) -> A {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyBoard.instantiateViewController(withIdentifier: "\(type)") as? A else { fatalError("ViewController indentifier incorrect") }
        return viewController
    }
    
    func createWeatherDetailController() -> WeatherViewController {
        let dataManager = WeatherDetailDataManager(weatherService: weatherService)
        let viewController = loadViewController(type: WeatherViewController.self)
        viewController.dataManager = dataManager
        return viewController
    }
    
    func startWithWeatherDetail() {
        setRootViewController(createWeatherDetailController())
    }
    
    func setRootViewController(_ viewController: UIViewController) {
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
    
}
