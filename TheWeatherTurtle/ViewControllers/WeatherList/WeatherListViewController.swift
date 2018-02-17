//
//  WeatherListViewController.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 12/02/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

import UIKit

final class WeatherListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    
    private var navigator: WeatherListNavigable!
    private var dataManager: WeatherDataManager!
    private var tableManager: WeatherListTableManager!
    private var cityIDs: [String]?

    static func instantiate(storyboard: UIStoryboard, navigator: WeatherListNavigable, dataManager: WeatherDataManager, cityIDs: [String]?) -> WeatherListViewController {
        let viewController = storyboard.instantiateViewController(withIdentifier: "\(self)") as! WeatherListViewController
        viewController.navigator = navigator
        viewController.dataManager = dataManager
        viewController.cityIDs = cityIDs
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Weather"

        tableManager = WeatherListTableManager(tableView: tableView, delegate: self)
        tableManager.prepareTableView()
        
        refreshControl.tintColor = .white
        refreshControl.attributedTitle = NSAttributedString(string: "Loading", attributes: [.foregroundColor :  UIColor.white])
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        createAddButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadWeather()
    }
    
    private func createAddButton() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToAddCity))
        navigationItem.rightBarButtonItem = addButton
    }
    
    //MARK: Services
    
    private func loadWeather() {
        update(with: .loading)
        cityIDs = dataManager.getUserCities()
        dataManager.getWeatherDetails(cities: cityIDs ?? []) { viewState in
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
            refreshControl.beginRefreshing()
            
        case .error:
            present(navigator.alertGeneralError(), animated: true, completion: nil)
            
        case .data(let viewModel):
            update(with: viewModel)
        }
    }
    
    private func prepare(for viewState: ViewState<WeatherListViewModel>) {
        refreshControl.endRefreshing()
    }
    
    private func update(with viewModel: WeatherListViewModel) {
        tableManager.reload(with: viewModel.cities)
    }
    
    //MARK: Navigation
    
    private func goToWeatherDetail(city: String) {
        navigator.pushWeatherDetail(city: city, on: navigationController)
    }
    
    @objc private func goToAddCity() {
        navigator.pushAddCityWeather(on: navigationController)
    }
}

extension WeatherListViewController: WeatherListTableManagerDelegate {
    func weatherListTableManager(_ tableManager: WeatherListTableManager, didSelectWeatherItem viewModel: WeatherViewModel) {
        goToWeatherDetail(city: viewModel.city)
    }
}
