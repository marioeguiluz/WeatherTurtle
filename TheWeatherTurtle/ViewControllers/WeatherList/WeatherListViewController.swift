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
    
    private static let defaultCitiesIDs = ["524901", "703448", "2643743"]
    
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
        
        tableManager = WeatherListTableManager(tableView: tableView, weatherManager: dataManager)
        tableManager.prepareTableView()
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
    
    //MARK: Update
    
    private func update(with viewState: ViewState<WeatherListViewModel>) {
        
        prepare(for: viewState)
        
        switch viewState {
        case .loading:
            print()
            //activityIndicator.startAnimating()
            
        case .error:
            present(navigator.alertGeneralError(), animated: true, completion: nil)
            
        case .data(let viewModel):
            update(with: viewModel)
        }
    }
    
    private func prepare(for viewState: ViewState<WeatherListViewModel>) {
//        activityIndicator.stopAnimating()
//        contentView.isHidden = viewState.isLoading()
//        loadingView.isHidden = !viewState.isLoading()
    }
    
    private func update(with viewModel: WeatherListViewModel) {
        tableManager.reload(with: viewModel.cities)
    }
}
