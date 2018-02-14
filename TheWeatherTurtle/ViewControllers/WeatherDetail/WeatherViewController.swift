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
    
    private static let defaultCity = "London"
    
    private var navigator: WeatherDetailNavigable!
    private var dataManager: WeatherDataManager!
    private var city: String!

    static func instantiate(storyboard: UIStoryboard, navigator: WeatherDetailNavigable, dataManager: WeatherDataManager, city: String?) -> WeatherViewController {
        let viewController = storyboard.instantiateViewController(withIdentifier: "\(self)") as! WeatherViewController
        viewController.navigator = navigator
        viewController.dataManager = dataManager
        viewController.city = city ?? WeatherViewController.defaultCity
        return viewController
    }
        
    //MARK: View Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadWeather()
    }
    
    //MARK: Services
    
    private func loadWeather() {
        update(with: .loading)
        dataManager.getWeatherDetails(city: city) { viewState in
            DispatchQueue.main.async {
                self.update(with: viewState)
            }
        }
    }
    
    //MARK: Update
    
    private func update(with viewState: ViewState<WeatherViewModel>) {
        
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
    
    private func prepare(for viewState: ViewState<WeatherViewModel>) {
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
        
        dataManager.getWeatherIcon(code: icon, completion: { (image) in
            DispatchQueue.main.async {
                self.iconImage.image =  image
            }
        })
    }
}
