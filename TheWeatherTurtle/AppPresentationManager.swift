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
    private let mainController = UINavigationController()
    
    init(window: UIWindow?, storyboardName: String = defaultStoryboardName) {
        self.window = window
        storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        
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
        mainController.setViewControllers([instantiateWeatherDetailController()], animated: false)
        setRootViewController(mainController)
    }

    // MARK: - View Controller Factory
    
    func instantiateWeatherDetailController(city: String? = nil) -> WeatherViewController {
        let viewManager = WeatherManager()
        let viewController = WeatherViewController.instantiate(storyboard: storyboard, viewManager: viewManager, city: city)
        return viewController
    }
}
