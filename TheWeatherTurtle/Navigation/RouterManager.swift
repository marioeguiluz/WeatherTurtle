//
//  RouterManager.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 09/02/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

import UIKit

private let defaultStoryboardName = "Main"

final class RouterManager {
    
    private weak var window: UIWindow?
    private let storyboard: UIStoryboard
    private let coreService: CoreService
    
    init(window: UIWindow?, storyboardName: String = defaultStoryboardName) {
        self.window = window
        storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        coreService = CoreService()
    }
    
    private func loadViewController<A: UIViewController>(type: A.Type) -> A {
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "\(type)") as? A else { fatalError("ViewController indentifier incorrect") }
        return viewController
    }
    
    private func setRootViewController(_ viewController: UIViewController) {
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
    
    func startWithWeatherDetail(city: String? = nil) {
        setRootViewController(instantiateWeatherDetailController(city: city))
    }

    func instantiateWeatherDetailController(city: String? = nil) -> WeatherViewController {
        let dataManager = WeatherDetailDataManager(weatherService: coreService.weatherService)
        let viewController = loadViewController(type: WeatherViewController.self)
        let navigator = WeatherDetailNavigator(routerManager: self, weatherViewController: viewController)

        viewController.navigator = navigator
        viewController.dataManager = dataManager
        viewController.city = city
        return viewController
    }
}
