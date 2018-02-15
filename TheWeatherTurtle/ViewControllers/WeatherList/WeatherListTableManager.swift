//
//  WeatherListTableManager.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 12/02/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

import UIKit

final class WeatherListTableManager: NSObject {
    
    private let identifier = "CityWeatherCell"
    
    private let tableView: UITableView
    private var items: [WeatherViewModel] = []
    
    init(tableView: UITableView) {
        self.tableView = tableView
    }
    
    func prepareTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    }
    
    func reload(with items: [WeatherViewModel]) {
        self.items = items
        tableView.reloadData()
    }
}

extension WeatherListTableManager: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CityWeatherCell
        let viewModel = items[indexPath.row]
        cell.update(viewModel)
        return cell
    }
}
