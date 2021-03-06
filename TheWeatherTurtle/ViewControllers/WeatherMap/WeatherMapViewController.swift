//
//  WeatherMapViewController.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 24/02/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

import UIKit
import MapKit

protocol WeatherMapViewControllerDelegate: class {
    func weatherMapViewController(_ weatherMapViewController: WeatherMapViewController, didAddCity: WeatherViewModel)
    func weatherMapViewController(_ weatherMapViewController: WeatherMapViewController, didSelectCity viewModel: WeatherViewModel)
}

final class WeatherMapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private weak var delegate: WeatherMapViewControllerDelegate?

    private var navigator: WeatherNavigable!
    private var weatherManager: WeatherManager!
    private var mapManager: WeatherMapManager!
    private var cityIDs: [String]?
    
    static func instantiate(storyboard: UIStoryboard, navigator: WeatherNavigable, weatherManager: WeatherManager, cityIDs: [String]? = nil, delegate: WeatherMapViewControllerDelegate? = nil) -> WeatherMapViewController {
        let viewController = storyboard.instantiateViewController(withIdentifier: "\(self)") as! WeatherMapViewController
        viewController.navigator = navigator
        viewController.weatherManager = weatherManager
        viewController.cityIDs = cityIDs
        viewController.delegate = delegate
        viewController.title = "Weather Map"
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapManager = WeatherMapManager(mapView: mapView, delegate: self)
        mapView.delegate = mapManager

        createAddButton()
        createLongPressAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadWeather()
    }
    
    private func createAddButton() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToAddCity))
        navigationItem.leftBarButtonItem = addButton
    }

    private func createLongPressAction() {
        let longPressRecogniser = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPressRecogniser.minimumPressDuration = 1
        mapView.addGestureRecognizer(longPressRecogniser)
    }
    
    //MARK: Services
    
    private func loadWeather() {
        cityIDs = weatherManager.userSelectedCities()
        weatherManager.getWeatherDetails(cityIDs: cityIDs ?? []) { viewState in
            DispatchQueue.main.async {
                self.update(with: viewState)
            }
        }
    }
    
    private func loadWeather(with coordinate: CLLocationCoordinate2D) {
        weatherManager.getWeatherDetails(latitude: coordinate.latitude, longitude: coordinate.longitude, storeCity: true) { viewState in
            DispatchQueue.main.async {
                self.addAnnotation(with: viewState)
            }
        }
    }
    
    @objc private func refresh() {
        loadWeather()
    }
    
    //MARK: Update
    
    func update(with viewState: ViewState<WeatherListViewModel>) {
        
        prepare()
        
        switch viewState {
        case .loading:
            activityIndicator.startAnimating()
            
        case .error:
            navigator.showAlertGeneralError()

        case .data(let viewModel):
            update(with: viewModel)
        }
    }
    
    func addAnnotation(with viewState: ViewState<WeatherViewModel>) {
        
        prepare()

        switch viewState {
        case .loading:
            activityIndicator.startAnimating()
            
        case .error:
            navigator.showAlertGeneralError()
        
        case .data(let viewModel):
            addAnnotation(with: viewModel)
            delegate?.weatherMapViewController(self, didAddCity: viewModel)
        }
    }
    
    private func prepare() {
        activityIndicator.stopAnimating()
    }
    
    private func update(with viewModel: WeatherListViewModel) {
        mapManager.reload(with: viewModel.cities)
    }
    
    private func addAnnotation(with viewModel: WeatherViewModel) {
        mapManager.addAnnotation(viewModel)
    }
    
    //MARK: Navigation
    
    private func goToWeatherDetail(city: String) {
        navigator.pushWeatherDetail(city: city)
    }
    
    @objc private func goToAddCity() {
        navigator.pushAddCityWeather()
    }

    //MARK: Actions

    @objc private func handleLongPress(_ gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state != .began { return }
        let touchPoint = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        loadWeather(with: coordinate)
    }
}

extension WeatherMapViewController: WeatherMapManagerDelegate {
    func weatherMapManager(_ weatherMapManager: WeatherMapManager, didSelect weatherViewModel: WeatherViewModel) {
        delegate?.weatherMapViewController(self, didSelectCity: weatherViewModel)
    }
}
