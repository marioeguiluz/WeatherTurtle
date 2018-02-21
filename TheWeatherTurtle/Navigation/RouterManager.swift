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

        setupAppearnce()
    }

    private func setupAppearnce() {
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
    
    func startWithWeatherList(cityIDs: [String]? = []) {
        setRootViewController(UINavigationController(rootViewController: instantiateWeatherListController(cityIDs: cityIDs)))
    }
    
    func startWithTabBar(cityIDs: [String]? = []) {
        let tabController = UITabBarController()
        let tabTable = UINavigationController(rootViewController: instantiateWeatherListController(cityIDs: cityIDs))
        let tabCollection = UINavigationController(rootViewController: instantiateWeatherCollectionController(cityIDs: cityIDs))
        tabController.viewControllers = [tabTable, tabCollection]
        setRootViewController(tabController)
    }

    func instantiateWeatherDetailController(city: String? = nil) -> WeatherViewController {
        let dataManager = WeatherDataManager(weatherService: coreService.weatherService, dataStoreService: coreService.dataStoreService)
        let navigator = WeatherDetailNavigator(routerManager: self)
        let viewController = WeatherViewController.instantiate(storyboard: storyboard, navigator: navigator, dataManager: dataManager, city: city)
        return viewController
    }
    
    func instantiateWeatherListController(cityIDs: [String]? = []) -> WeatherListViewController {
        let dataManager = WeatherDataManager(weatherService: coreService.weatherService, dataStoreService: coreService.dataStoreService)
        let navigator = WeatherNavigator(routerManager: self)
        let viewController = WeatherListViewController.instantiate(storyboard: storyboard, navigator: navigator, dataManager: dataManager, cityIDs: cityIDs)
        return viewController
    }
    
    func instantiateAddCityController() -> AddCityViewController {
        let dataManager = WeatherDataManager(weatherService: coreService.weatherService, dataStoreService: coreService.dataStoreService)
        let navigator = AddCityNavigator(routerManager: self)
        let viewController = AddCityViewController.instantiate(storyboard: storyboard, navigator: navigator, dataManager: dataManager)
        return viewController
    }
    
    func instantiateWeatherCollectionController(cityIDs: [String]? = []) -> WeatherCollectionViewController {
        let dataManager = WeatherDataManager(weatherService: coreService.weatherService, dataStoreService: coreService.dataStoreService)
        let navigator = WeatherNavigator(routerManager: self)
        let viewController = WeatherCollectionViewController.instantiate(storyboard: storyboard, navigator: navigator, dataManager: dataManager, cityIDs: cityIDs)
        return viewController
    }
}
