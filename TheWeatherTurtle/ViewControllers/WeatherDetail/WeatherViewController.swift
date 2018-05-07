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
    
    private var viewManager: WeatherManager!
    private var cityID: String!

    static func instantiate(storyboard: UIStoryboard, viewManager: WeatherManager, city: String?) -> WeatherViewController {
        let viewController = storyboard.instantiateViewController(withIdentifier: "\(self)") as! WeatherViewController
        viewController.viewManager = viewManager
        viewController.cityID = city ?? WeatherViewController.defaultCity
        viewController.title = "Forecast Today"
        return viewController
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
        
    //MARK: View Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        dismissButton.isHidden = navigationController != nil
        loadViewModel()
    }
    
    //MARK: - Bad code
    
    private func loadViewModel() {
        activityIndicator.startAnimating()
        viewManager.getWeatherDetailsViewModel(cityID: cityID) { [weak self] viewModel in
            self?.labelCity.text = viewModel.cityAndDescription
            self?.backgroundImageView.image = viewModel.backgroundImage
            self?.contentView.backgroundColor = viewModel.backgroundColor
            self?.labelTemperature.text = viewModel.temperatureString
            DispatchQueue.global().async {
                if let image = try? UIImage(data: Data(contentsOf: viewModel.iconURL, options: Data.ReadingOptions.uncached)) {
                    DispatchQueue.main.async {
                        self?.iconImage.image = image
                    }
                }
            }
        }
    }
}
