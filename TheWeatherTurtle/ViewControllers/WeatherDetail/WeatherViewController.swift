//
//  WeatherViewController.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 07/02/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

import UIKit

final class WeatherViewController: UIViewController, UIViewControllerTransitioningDelegate {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var labelCity: UILabel!
    @IBOutlet weak var labelTemperature: UILabel!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var dismissButton: UIButton!
    
    private static let defaultCity = "London"
    
    private var navigator: Navigable!
    private var dataManager: WeatherDataManager!
    private var cityID: String!

    static func instantiate(storyboard: UIStoryboard, navigator: Navigable, dataManager: WeatherDataManager, city: String?) -> WeatherViewController {
        let viewController = storyboard.instantiateViewController(withIdentifier: "\(self)") as! WeatherViewController
        viewController.navigator = navigator
        viewController.dataManager = dataManager
        viewController.cityID = city ?? WeatherViewController.defaultCity
        viewController.title = "Forecast Today"
        return viewController
    }
        
    //MARK: View Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        dismissButton.isHidden = navigationController != nil
        loadWeather()
    }
    
    //MARK: Services
    
    private func loadWeather() {
        update(with: .loading)
        dataManager.getWeatherDetails(cityID: cityID) { viewState in
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
        labelCity.text = viewModel.city + ", " + viewModel.detail
        labelTemperature.text = viewModel.temperature
        backgroundImageView.image = viewModel.temperatureCategory.cellBackgroundImage()
        view.backgroundColor = viewModel.temperatureCategory.backgroundColor()
        ImageDownloader.shared.setImage(from: viewModel.icon, completion: { [weak self] (image) in
            self?.iconImage.image = image
        })
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
