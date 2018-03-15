//
//  WeatherListNavigable.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 10/02/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

import UIKit

protocol WeatherNavigable: Navigable {
    func pushWeatherDetail(city: String)
    func presentWeatherDetail(city: String, originFrame: CGRect)
    func pushAddCityWeather()
}

extension WeatherNavigable {
    func pushWeatherDetail(city: String) {
        let detailVC = appPresentationManager.instantiateWeatherDetailController(city: city)
        appPresentationManager.rootNavController()?.pushViewController(detailVC, animated: true)
    }
    
    func presentWeatherDetail(city: String, originFrame: CGRect) {
        let detailVC = appPresentationManager.instantiateWeatherDetailController(city: city)
        appPresentationManager.selectedViewController().present(detailVC, animated: true, completion: nil)
    }
    
    func pushAddCityWeather() {
        let addVC = appPresentationManager.instantiateAddCityController()
        appPresentationManager.rootNavController()?.pushViewController(addVC, animated: true)
    }
}

final class WeatherNavigator: NSObject, WeatherNavigable {
    let appPresentationManager: AppPresentationManager
    let animator = Animator()
    var originFrame: CGRect = .zero
    
    init(appPresentationManager: AppPresentationManager) {
        self.appPresentationManager = appPresentationManager
    }
    
    func presentWeatherDetail(city: String, originFrame: CGRect) {
        let detailVC = appPresentationManager.instantiateWeatherDetailController(city: city)
        animator.originFrame = originFrame
        detailVC.transitioningDelegate = self
        appPresentationManager.selectedViewController().present(detailVC, animated: true, completion: nil)
    }
}

extension WeatherNavigator: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.presenting = true
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.presenting = false
        return animator
    }
}
