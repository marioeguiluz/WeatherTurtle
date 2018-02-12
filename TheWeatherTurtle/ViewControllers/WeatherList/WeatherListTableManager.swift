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
    private var weatherManager: WeatherDataManager?
    private var items: [WeatherViewModel] = []
    private var imageCache: [String: UIImage] = [:]
    
    init(tableView: UITableView, weatherManager: WeatherDataManager?) {
        self.tableView = tableView
        self.weatherManager = weatherManager
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
    
    private func setImage(with url: String, on cell: CityWeatherCell) {
        if let cachedImage =  imageCache[url] {
            cell.imageViewWeather?.image = cachedImage
        } else {
            self.weatherManager?.getWeatherIcon(code: url, completion: { (image) in
                DispatchQueue.main.async {
                    self.imageCache[url] = image
                    cell.imageViewWeather?.image = image
                }
            })
        }
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
        if let imageUrl = viewModel.icon {
            setImage(with: imageUrl, on: cell)
        }
        
        return cell
    }
}
