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

    private let searchController = UISearchController(searchResultsController: nil)
    private var navigator: AddCityNavigable!
    private var dataManager: WeatherDataManager!
    private var tableManager: AddCityTableManager!
    
    static func instantiate(storyboard: UIStoryboard, navigator: AddCityNavigable, dataManager: WeatherDataManager) -> AddCityViewController {
        let viewController = storyboard.instantiateViewController(withIdentifier: "\(self)") as! AddCityViewController
        viewController.navigator = navigator
        viewController.dataManager = dataManager
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
    
    //MARK: Services
    
    private func loadCities() {
        update(with: .loading)
        dataManager.getAllCities { viewState in
            self.update(with: viewState)
        }
    }

    //MARK: Update
    
    private func update(with viewState: ViewState<AddCityViewModel>) {
        
        prepare(for: viewState)

        switch viewState {
        case .loading:
            print("Loading")

        case .error:
            guard let navigator = navigator else { fatalError("Navigator not set") }
            present(navigator.alertGeneralError(), animated: true, completion: nil)

        case .data(let viewModel):
            update(with: viewModel)
            searchController.isActive = true
        }
    }
    
    private func prepare(for viewState: ViewState<AddCityViewModel>) {
        print("PrepareUI")
    }
    
    private func update(with viewModel: AddCityViewModel) {
        tableManager.update(with: viewModel.allCities)
    }
}

extension AddCityViewController: AddCityTableManagerDelegate {
    func addCityTableManager(_ tableManager: AddCityTableManager, didSelectCity viewModel: City) {
        if let cityID = viewModel.id, dataManager.storeCity("\(cityID)") {
            navigationController?.popViewController(animated: true)
        } else {
            update(with: .error)
        }
    }
}
