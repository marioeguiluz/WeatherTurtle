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
    private var dataManager: WeatherDataManager!
    private var collectionManager: WeatherCollectionManager!
    private var cityIDs: [String]?
    
    static func instantiate(storyboard: UIStoryboard, navigator: WeatherNavigable, dataManager: WeatherDataManager, cityIDs: [String]?) -> WeatherCollectionViewController {
        let viewController = storyboard.instantiateViewController(withIdentifier: "\(self)") as! WeatherCollectionViewController
        viewController.navigator = navigator
        viewController.dataManager = dataManager
        viewController.cityIDs = cityIDs
        viewController.title = "Weather Collection"
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionManager = WeatherCollectionManager(collectionView: collectionView, delegate: self)
        collectionManager.prepareCollectionView()

        createAddButton()
        createModeTestButton()
        addPinchGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadWeather()
    }
    
    private func createAddButton() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToAddCity))
        navigationItem.leftBarButtonItem = addButton
    }
    
    private func createModeTestButton() {
        let modeButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(toggleMode))
        navigationItem.rightBarButtonItem = modeButton
    }
    
    private func addPinchGesture() {
        let gesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        view.addGestureRecognizer(gesture)
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
    
    @objc private func toggleMode() {
        collectionManager.toggleMode()
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
        collectionManager.reload(with: viewModel.cities)
    }
    
    //MARK: Navigation
    
    private func goToWeatherDetail(city: String) {
        navigator.pushWeatherDetail(city: city, on: navigationController)
    }
    
    @objc private func goToAddCity() {
        navigator.pushAddCityWeather(on: navigationController)
    }
    
    @objc private func handlePinch(_ pinchGestureRecognizer: UIPinchGestureRecognizer) {
        guard pinchGestureRecognizer.state != .began else { return }
        if pinchGestureRecognizer.state == .ended {
            toggleMode()
        }
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
}
