//
//  WeatherListTableManager.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 12/02/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

import UIKit

protocol WeatherListTableManagerDelegate: class {
    func weatherListTableManager(_ tableManager: WeatherListTableManager, didSelectWeatherItem viewModel: WeatherViewModel, frame: CGRect)
    func weatherListTableManager(_ tableManager: WeatherListTableManager, willRemoveWeatherItem viewModel: WeatherViewModel, at indexPath: IndexPath)
    func weatherListTableManager(_ tableManager: WeatherListTableManager, isEditing: Bool)
}

final class WeatherListTableManager: NSObject {
    
    private let identifier = "CityWeatherCell"
    
    private weak var delegate: WeatherListTableManagerDelegate?
    private let tableView: UITableView
    private var items: [WeatherViewModel] = []
    
    init(tableView: UITableView, delegate: WeatherListTableManagerDelegate) {
        self.tableView = tableView
        self.delegate = delegate
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
    
    func toggleEditMode() {
        let isEditing = !tableView.isEditing
        tableView.isEditing = isEditing
        guard let delegate = delegate else {
            fatalError("Delegate not set in \(#file) : \(#function)")
        }
        delegate.weatherListTableManager(self, isEditing: isEditing)
    }
    
    func remove(indexPath: IndexPath) {
        items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .right)
    }
    
    private func willRemoveRow(at indexPath: IndexPath){
        guard let delegate = delegate else {
            fatalError("Delegate not set in \(#file) : \(#function)")
        }
        delegate.weatherListTableManager(self, willRemoveWeatherItem: items[indexPath.row], at: indexPath)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let delegate = delegate else {
            fatalError("Delegate not set in \(#file) : \(#function)")
        }
        
        let cell = tableView.cellForRow(at: indexPath) as? CityWeatherCell
        guard let thumbnail = cell?.imageViewBackground, let thumbnailSuperview = thumbnail.superview else { return }
        let originRect = thumbnailSuperview.convert(thumbnail.frame, to: nil)
        
        delegate.weatherListTableManager(self, didSelectWeatherItem: items[indexPath.row], frame: originRect)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            willRemoveRow(at: indexPath)
        default:
            return
        }
    }
}
