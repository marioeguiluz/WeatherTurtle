//
//  AddCityTableManager.swift
//  TheWeatherTurtle
//
//  Created by MARIO EGUILUZ ALEBICTO on 17/02/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

import UIKit

protocol AddCityTableManagerDelegate: class {
    func addCityTableManager(_ tableManager: AddCityTableManager, didSelectCity viewModel: City)
}

final class AddCityTableManager: NSObject {

    private let identifier = "AddCityCell"

    private weak var delegate: AddCityTableManagerDelegate?
    private weak var searchController: UISearchController?

    private let tableView: UITableView

    private var items: [City] = []
    private var results: [City] = []

    init(tableView: UITableView, delegate: AddCityTableManagerDelegate) {
        self.tableView = tableView
        self.delegate = delegate
    }

    func prepareTableView(with searchController: UISearchController) {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)

        self.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search Cities"
        searchController.searchBar.delegate = self
    }

    func update(with items: [City]) {
        self.items = items
    }
}

extension AddCityTableManager: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! AddCityCell
        let viewModel = results[indexPath.row]
        cell.update(viewModel)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let delegate = delegate else {
            fatalError("Delegate not set in \(#file) : \(#function)")
        }
        delegate.addCityTableManager(self, didSelectCity: results[indexPath.row])
    }
}

extension AddCityTableManager {

    private func search(text: String) {
        DispatchQueue.global().async {
            self.results = self.items
                .filter { city in
                    guard let cityName = city.name else {
                        return false
                    }
                    return cityName.lowercased().contains(text.lowercased())
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    private func searchBarEmpty() -> Bool {
        guard let searchController = searchController else { return true }
        return searchController.searchBar.text?.isEmpty ?? true
    }

    private func isFiltering() -> Bool {
        guard let searchController = searchController else { return false }
        let isFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarEmpty() || isFiltering)
    }
}

extension AddCityTableManager: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        guard let query = searchBar.text, query.count > 2 else {
            return
        }
        search(text: query)
    }
}

extension AddCityTableManager: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text, query.count > 2 else {
            return
        }
        search(text: query)
    }
}
