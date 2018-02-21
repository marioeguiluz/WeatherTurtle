//
//  WeatherCollectionManager.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 21/02/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

import UIKit

enum CollectionWeatherMode {
    case expanded
    case collapsed
}

protocol WeatherCollectionManagerDelegate: class {
    func weatherCollectionManager(_ collectionManager: WeatherCollectionManager, didSelectWeatherItem viewModel: WeatherViewModel)
}

final class WeatherCollectionManager: NSObject {
    
    private let identifier = "CollectionWeatherCell"
    
    private weak var delegate: WeatherCollectionManagerDelegate?
    private let collectionView: UICollectionView
    private var items: [WeatherViewModel] = []
    private var mode: CollectionWeatherMode = .expanded
    
    init(collectionView: UICollectionView, delegate: WeatherCollectionManagerDelegate) {
        self.collectionView = collectionView
        self.delegate = delegate
    }
    
    func prepareCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
    }
    
    func toggleMode() {
        mode = mode == .expanded ? .collapsed : .expanded
        collectionView.reloadData()
    }
    
    func reload(with items: [WeatherViewModel]) {
        self.items = items
        collectionView.reloadData()
    }
}

extension WeatherCollectionManager: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch mode {
        case .collapsed:
            return CGSize(width: collectionView.frame.width/3, height: collectionView.frame.height)
        case .expanded:
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! CollectionWeatherCell
        let viewModel = items[indexPath.row]
        cell.update(viewModel, mode: mode)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let delegate = delegate else {
            fatalError("Delegate not set in \(#file) : \(#function)")
        }
        delegate.weatherCollectionManager(self, didSelectWeatherItem: items[indexPath.row])
    }
}

