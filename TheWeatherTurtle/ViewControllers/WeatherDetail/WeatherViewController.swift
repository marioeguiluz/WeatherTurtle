//
//  WeatherViewController.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 07/02/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

import UIKit

final class WeatherViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var labelCity: UILabel!
    @IBOutlet weak var labelTemperature: UILabel!
    @IBOutlet weak var labelDetail: UILabel!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var dataManager: WeatherDetailDataManager?
    
    //MARK: View Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadWeather()
    }
    
    //MARL: Load data
    
    private func loadWeather() {
        guard let dataManager = dataManager else { fatalError("DataManager not set") }
        
        dataManager.getWeatherDetails(city: "London") { [weak self] (viewState) in
            DispatchQueue.main.async {
                self?.update(with: viewState)
            }
        }
    }
    
    //MARK: Update
    
    private func update(with viewState: WeatherViewState) {
        
        setupViews(with: viewState)
        
        switch viewState {
        case .loading:
            activityIndicator.startAnimating()
            
        case .error:
            showError()
            
        case .data(let viewModel):
            update(with: viewModel)
        }
    }
    
    private func setupViews(with viewState: WeatherViewState) {
        activityIndicator.stopAnimating()
        contentView.isHidden = viewState.isLoading()
        loadingView.isHidden = !viewState.isLoading()
    }
    
    private func showError() {
        let alert = UIAlertController(title: "Error", message: "General issue", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    private func update(with viewModel: WeatherViewModel) {
        labelCity.text = viewModel.city
        labelTemperature.text = "\(viewModel.temperature)"
        labelDetail.text = viewModel.detail
    }
}
