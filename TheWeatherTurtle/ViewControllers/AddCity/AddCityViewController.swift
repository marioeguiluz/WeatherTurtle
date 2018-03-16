//
//  AddCityViewController.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 16/02/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

import UIKit

final class AddCityViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var navigator: Navigable!
    private var viewManager: WeatherManager!
    private var tableManager: AddCityTableManager!
    
    static func instantiate(storyboard: UIStoryboard, navigator: Navigable, viewManager: WeatherManager) -> AddCityViewController {
        let viewController = storyboard.instantiateViewController(withIdentifier: "\(self)") as! AddCityViewController
        viewController.navigator = navigator
        viewController.viewManager = viewManager
        viewController.title = "Add City"
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableManager = AddCityTableManager(tableView: tableView, delegate: self)
        tableManager.prepareTableView(with: searchController)

        definesPresentationContext = true
        navigationItem.searchController = searchController
    }

    //MARK: View Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCities()
    }
    

    override func viewDidDisappear(_ animated: Bool) {
        if presentingViewController == nil {
            searchController.dismiss(animated: false, completion: nil)
        }
        super.viewDidDisappear(animated)
    }
    
    //MARK: Services
    
    private func loadCities() {
        viewManager.searchableCities { [weak self] viewState in
            self?.update(with: viewState)
        }
    }

    //MARK: Update
    
    func update(with viewState: ViewState<AddCityViewModel>) {
        
        prepare(for: viewState)

        switch viewState {
        case .loading:
            activityIndicator.startAnimating()

        case .error:
            navigator.showAlertGeneralError()

        case .data(let viewModel):
            update(with: viewModel)
            searchController.isActive = true
        }
    }
    
    private func prepare(for viewState: ViewState<AddCityViewModel>) {
        activityIndicator.stopAnimating()
    }
    
    private func update(with viewModel: AddCityViewModel) {
        tableManager.update(with: viewModel.allCities)
    }
}

extension AddCityViewController: AddCityTableManagerDelegate {
    func addCityTableManager(_ tableManager: AddCityTableManager, didSelectCity viewModel: City) {
        if let cityID = viewModel.id, viewManager.storeCity("\(cityID)") {
            navigator.showAlertSuccess(title: "Success", message: "City Added", completion: { [weak self] in
                self?.navigator.pop()
            })
        } else {
            update(with: .error)
        }
    }
}
