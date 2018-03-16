//
//  WeatherCollectionViewController.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 21/02/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

import UIKit

final class WeatherCollectionViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    private var navigator: WeatherNavigable!
    private var viewManager: WeatherManager!
    private var collectionManager: WeatherCollectionManager!
    private var cityIDs: [String]?
    
    static func instantiate(storyboard: UIStoryboard, navigator: WeatherNavigable, viewManager: WeatherManager, cityIDs: [String]?) -> WeatherCollectionViewController {
        let viewController = storyboard.instantiateViewController(withIdentifier: "\(self)") as! WeatherCollectionViewController
        viewController.navigator = navigator
        viewController.viewManager = viewManager
        viewController.cityIDs = cityIDs
        viewController.title = "Weather Collection"
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionManager = WeatherCollectionManager(collectionView: collectionView, delegate: self)
        collectionManager.prepareCollectionView()

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
        cityIDs = viewManager.userSelectedCities()
        viewManager.getWeatherDetails(cityIDs: cityIDs ?? []) { viewState in
            DispatchQueue.main.async {
                self.update(with: viewState)
            }
        }
    }
    
    @objc private func refresh() {
        loadWeather()
    }
    
    //MARK: Update
    
    func update(with viewState: ViewState<WeatherListViewModel>) {
        
        prepare(for: viewState)
        
        switch viewState {
        case .loading:
            activityIndicator.startAnimating()
            
        case .error:
            navigator.showAlertGeneralError()
            
        case .data(let viewModel):
            update(with: viewModel)
        }
    }
    
    private func prepare(for viewState: ViewState<WeatherListViewModel>) {
        activityIndicator.stopAnimating()
    }
    
    private func update(with viewModel: WeatherListViewModel) {
        collectionManager.reload(with: viewModel.cities)
    }
    
    //MARK: Navigation
    
    private func goToWeatherDetail(city: String) {
        navigator.pushWeatherDetail(city: city)
    }
    
    @objc private func goToAddCity() {
        navigator.pushAddCityWeather()
    }
}

extension WeatherCollectionViewController: WeatherCollectionManagerDelegate {
    func weatherCollectionManager(_ collectionManager: WeatherCollectionManager, didSelectWeatherItem viewModel: WeatherViewModel) {
        goToWeatherDetail(city: viewModel.id)
    }
}

extension WeatherCollectionViewController: WeatherMapViewControllerDelegate {
    func weatherMapViewController(_ weatherMapViewController: WeatherMapViewController, didAddCity: WeatherViewModel) {
        refresh()
    }
    
    func weatherMapViewController(_ weatherMapViewController: WeatherMapViewController, didSelectCity viewModel: WeatherViewModel) {
        collectionManager.scrollToCity(with: viewModel.id)
    }
}
