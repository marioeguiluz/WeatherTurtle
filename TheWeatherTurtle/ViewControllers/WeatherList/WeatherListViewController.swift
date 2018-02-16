//
//  WeatherListViewController.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 12/02/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

import UIKit

final class WeatherListViewController: UIViewController {
    
    private static let defaultCitiesIDs = ["524901", "703448", "2643743"]

    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    
    private var navigator: WeatherListNavigable!
    private var dataManager: WeatherDataManager!
    private var tableManager: WeatherListTableManager!
    private var cities: [String]!

    static func instantiate(storyboard: UIStoryboard, navigator: WeatherListNavigable, dataManager: WeatherDataManager, cities: [String]?) -> WeatherListViewController {
        let viewController = storyboard.instantiateViewController(withIdentifier: "\(self)") as! WeatherListViewController
        viewController.navigator = navigator
        viewController.dataManager = dataManager
        viewController.cities = cities ?? WeatherListViewController.defaultCitiesIDs
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableManager = WeatherListTableManager(tableView: tableView, delegate: self)
        tableManager.prepareTableView()
        
        refreshControl.tintColor = .white
        refreshControl.attributedTitle = NSAttributedString(string: "Loading", attributes: [.foregroundColor :  UIColor.white])
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadWeather()
    }
    
    //MARK: Services
    
    private func loadWeather() {
        update(with: .loading)
        dataManager.getWeatherDetails(cities: cities) { viewState in
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
}

extension WeatherListViewController: WeatherListTableManagerDelegate {
    func weatherListTableManager(_ tableManager: WeatherListTableManager, didSelectWeatherItem viewModel: WeatherViewModel) {
        navigator.pushWeatherDetail(city: viewModel.city, on: navigationController)
    }
}
