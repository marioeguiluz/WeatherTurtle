//
//  WeatherMapViewController.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 24/02/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

import UIKit
import MapKit

final class WeatherMapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var navigator: WeatherNavigable!
    private var dataManager: WeatherDataManager!
    private var mapManager: WeatherMapManager!
    private var cityIDs: [String]?
    
    static func instantiate(storyboard: UIStoryboard, navigator: WeatherNavigable, dataManager: WeatherDataManager, cityIDs: [String]?) -> WeatherMapViewController {
        let viewController = storyboard.instantiateViewController(withIdentifier: "\(self)") as! WeatherMapViewController
        viewController.navigator = navigator
        viewController.dataManager = dataManager
        viewController.cityIDs = cityIDs
        viewController.title = "Weather Map"
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapManager = WeatherMapManager(mapView: mapView, delegate: self)
        mapView.delegate = mapManager
        createAddButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadWeather()
    }
    
    private func createAddButton() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToAddCity))
        navigationItem.leftBarButtonItem = addButton
    }
    
    //MARK: Services
    
    private func loadWeather() {
        update(with: .loading)
        cityIDs = dataManager.getUserCities()
        dataManager.getWeatherDetails(cityIDs: cityIDs ?? []) { viewState in
            DispatchQueue.main.async {
                self.update(with: viewState)
            }
        }
    }
    
    @objc private func refresh() {
        loadWeather()
    }
    
    //MARK: Update
    
    private func update(with viewState: ViewState<WeatherListViewModel>) {
        
        prepare(for: viewState)
        
        switch viewState {
        case .loading:
            activityIndicator.startAnimating()
            
        case .error:
            present(navigator.alertGeneralError(), animated: true, completion: nil)
            
        case .data(let viewModel):
            update(with: viewModel)
        }
    }
    
    private func prepare(for viewState: ViewState<WeatherListViewModel>) {
        activityIndicator.stopAnimating()
    }
    
    private func update(with viewModel: WeatherListViewModel) {
        mapManager.reload(with: viewModel.cities)
    }
    
    //MARK: Navigation
    
    private func goToWeatherDetail(city: String) {
        navigator.pushWeatherDetail(city: city, on: navigationController)
    }
    
    @objc private func goToAddCity() {
        navigator.pushAddCityWeather(on: navigationController)
    }
}

extension WeatherMapViewController: WeatherMapManagerDelegate {

}
