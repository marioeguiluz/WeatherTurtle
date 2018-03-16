//
//  AppPresentationManager.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 09/02/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

import UIKit

private let defaultStoryboardName = "Main"

final class AppPresentationManager {
    
    private weak var window: UIWindow?
    private let storyboard: UIStoryboard
    private let coreRepository: CoreRepository
    private let mainController = UINavigationController()
    
    init(window: UIWindow?, storyboardName: String = defaultStoryboardName) {
        self.window = window
        storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        coreRepository = CoreRepository()
        
        setupAppearance()
    }

    private func setupAppearance() {
        UINavigationBar.appearance().backgroundColor = .white
        UINavigationBar.appearance().tintColor = .darkGray
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.darkGray]
        UISearchBar.appearance().tintColor = .darkGray
        UITabBar.appearance().tintColor = .darkGray
        UITabBar.appearance().backgroundColor = .white
    }

    private func setRootViewController(_ viewController: UIViewController) {
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
    
    func startWithNavBar(cityIDs: [String]? = []) {
        mainController.setViewControllers([instantiateWeatherListController(cityIDs: cityIDs)], animated: false)
        setRootViewController(mainController)
    }
    
    func selectedViewController() -> UIViewController {
        guard let selectedViewController = mainController.visibleViewController else {
            fatalError()
        }
        return selectedViewController
    }
    
    func rootNavController() -> UINavigationController? {
        return mainController
    }
    
    private func weatherDataManager() -> WeatherManager {
        return WeatherManager(weatherRepository: coreRepository.weatherRepository, dataStoreRepository: coreRepository.dataStoreRepository)
    }
    
    // MARK: - View Controller Factory
    
    func instantiateWeatherDetailController(city: String? = nil) -> WeatherViewController {
        let viewManager = weatherDataManager()
        let navigator = Navigator(appPresentationManager: self)
        let viewController = WeatherViewController.instantiate(storyboard: storyboard, navigator: navigator, viewManager: viewManager, city: city)
        return viewController
    }
    
    func instantiateWeatherListController(cityIDs: [String]? = []) -> WeatherListViewController {
        let viewManager = weatherDataManager()
        let navigator = WeatherNavigator(appPresentationManager: self)
        let viewController = WeatherListViewController.instantiate(storyboard: storyboard, navigator: navigator, viewManager: viewManager, cityIDs: cityIDs)
        return viewController
    }
    
    func instantiateAddCityController() -> AddCityViewController {
        let viewManager = weatherDataManager()
        let navigator = Navigator(appPresentationManager: self)
        let viewController = AddCityViewController.instantiate(storyboard: storyboard, navigator: navigator, viewManager: viewManager)
        return viewController
    }
}
