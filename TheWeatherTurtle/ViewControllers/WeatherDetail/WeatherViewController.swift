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
    @IBOutlet weak var iconImage: UIImageView!
    
    let defaultCity = "London"
    
    var navigator: WeatherDetailNavigable?
    var dataManager: WeatherDetailDataManager?
    var city: String?
        
    //MARK: View Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadWeather()
    }
    
    //MARK: Services
    
    func loadWeather() {
        guard let dataManager = dataManager else { fatalError("DataManager not set") }
        
        update(with: .loading)
        dataManager.getWeatherDetails(city: city ?? defaultCity) { viewState in
            DispatchQueue.main.async {
                self.update(with: viewState)
            }
        }
    }
    
    //MARK: Update
    
    private func update(with viewState: WeatherViewState) {
        
        prepare(for: viewState)
        
        switch viewState {
        case .loading:
            activityIndicator.startAnimating()
            
        case .error:
            guard let navigator = navigator else { fatalError("Navigator not set") }
            present(navigator.alertGeneralError(), animated: true, completion: nil)
            
        case .data(let viewModel):
            update(with: viewModel)
        }
    }
    
    private func prepare(for viewState: WeatherViewState) {
        activityIndicator.stopAnimating()
        contentView.isHidden = viewState.isLoading()
        loadingView.isHidden = !viewState.isLoading()
    }
    
    private func update(with viewModel: WeatherViewModel) {
        labelCity.text = viewModel.city
        labelTemperature.text = viewModel.temperature
        labelDetail.text = viewModel.detail
        displayIcon(with: viewModel)
    }
    
    private func displayIcon(with viewModel: WeatherViewModel) {
        guard let icon = viewModel.icon else {
            iconImage.image = nil
            return
        }
        
        DispatchQueue.global().async {
            self.dataManager?.getWeatherIcon(code: icon, completion: { (image) in
                DispatchQueue.main.async {
                    self.iconImage.image =  image
                }
            })
        }
    }
}
