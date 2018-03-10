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
    private var editButton: UIBarButtonItem?
    
    private var navigator: WeatherNavigable!
    private var dataManager: WeatherDataManager!
    private var tableManager: WeatherListTableManager!
    private var cityIDs: [String]?
    
    static func instantiate(storyboard: UIStoryboard, navigator: WeatherNavigable, dataManager: WeatherDataManager, cityIDs: [String]?) -> WeatherListViewController {
        let viewController = storyboard.instantiateViewController(withIdentifier: "\(self)") as! WeatherListViewController
        viewController.navigator = navigator
        viewController.dataManager = dataManager
        viewController.cityIDs = cityIDs
        viewController.title = "Weather List"
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
        
        createEditAddButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadWeather()
    }
    
    private func createEditAddButtons() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToAddCity))
        navigationItem.leftBarButtonItem = addButton
        
        editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(toggleEditMode))
        navigationItem.rightBarButtonItem = editButton
    }
    
    //MARK: Services
    
    private func loadWeather() {
        update(with: .loading)
        cityIDs = dataManager.userSelectedCities()
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
    
    @objc private func toggleEditMode() {
        tableManager.toggleEditMode()
    }
    
    //MARK: Navigation
    
    private func goToWeatherDetail(city: String) {
        //navigator.pushWeatherDetail(city: city, on: navigationController)
        navigator.presentWeatherDetail(city: city, on: self, originFrame: CGRect(x: 100, y: 100, width: 100, height: 100))
    }
    
    @objc private func goToAddCity() {
        navigator.pushAddCityWeather(on: navigationController)
    }
}

extension WeatherListViewController: WeatherListTableManagerDelegate {
    func weatherListTableManager(_ tableManager: WeatherListTableManager, didSelectWeatherItem viewModel: WeatherViewModel) {
        goToWeatherDetail(city: viewModel.id)
    }
    
    func weatherListTableManager(_ tableManager: WeatherListTableManager, willRemoveWeatherItem viewModel: WeatherViewModel, at indexPath: IndexPath) {
        guard dataManager.removeCity(viewModel.id) else {
            update(with: .error)
            return
        }
        tableManager.remove(indexPath: indexPath)
    }
    
    func weatherListTableManager(_ tableManager: WeatherListTableManager, isEditing: Bool) {
        editButton?.title = isEditing ? "Done" : "Edit"
    }
}
