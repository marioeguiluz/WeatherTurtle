//
//  WeatherContainerViewController.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 02/03/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

import UIKit

final class WeatherContainerViewController: UIViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    private var navigator: WeatherNavigable!
    private var topViewController: UIViewController!
    private var bottomViewController: UIViewController!

    static func instantiate(storyboard: UIStoryboard, navigator: WeatherNavigable, mapController: UIViewController, detailController: UIViewController) -> WeatherContainerViewController {
        let viewController = storyboard.instantiateViewController(withIdentifier: "\(self)") as! WeatherContainerViewController
        viewController.navigator = navigator
        viewController.topViewController = mapController
        viewController.bottomViewController = detailController
        viewController.title = "World Weather"
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViewControllers()
        createAddButton()
    }
    
    private func addViewControllers() {
        addChildViewController(topViewController)
        topViewController.view.frame = topView.bounds
        topView.addSubview(topViewController.view)
        topViewController.didMove(toParentViewController: self)
        
        addChildViewController(bottomViewController)
        bottomViewController.view.frame = bottomView.bounds
        bottomView.addSubview(bottomViewController.view)
        bottomViewController.didMove(toParentViewController: self)
    }
    
    private func createAddButton() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToAddCity))
        navigationItem.leftBarButtonItem = addButton
    }
    
    //MARK: Navigation
    
    @objc private func goToAddCity() {
        navigator.pushAddCityWeather()
    }
}
