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
    
    private let defaultCitiesIDs = ["524901", "703448", "2643743"]
    
    var navigator: WeatherListNavigable?
    var dataManager: WeatherDataManager?
    var tableManager: WeatherListTableManager?
    var cities: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableManager = WeatherListTableManager(tableView: tableView, weatherManager: dataManager)
        tableManager?.prepareTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadWeather()
    }
    
    //MARK: Services
    
    private func loadWeather() {
        guard let dataManager = dataManager else { fatalError("DataManager not set") }
        
        update(with: .loading)
        dataManager.getWeatherDetails(cities: cities ?? defaultCitiesIDs) { viewState in
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
            guard let navigator = navigator else { fatalError("Navigator not set") }
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
        tableManager?.reload(with: viewModel.cities)
    }
}
