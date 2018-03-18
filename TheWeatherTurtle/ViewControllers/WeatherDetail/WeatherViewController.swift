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
        loadWeather()
    }
    
    //MARK: - Bad code
    
    private func loadWeather() {
        activityIndicator.startAnimating()
        viewManager.getWeatherDetailsRaw(cityID: cityID) { [weak self] weatherDetails in
            if let name = weatherDetails.name, let description = weatherDetails.weather?.first?.description {
                self?.labelCity.text = name + ", " + description
            }
            if let temp = weatherDetails.main?.temp {
                self?.backgroundImageView.image = self?.cellBackgroundImage(for: temp)
                self?.contentView.backgroundColor = self?.backgroundColor(for: temp)
                self?.labelTemperature.text = String(format: "%.0f", temp.rounded(.toNearestOrEven)) + "°"
            }
            
            if let icon = weatherDetails.weather?.first?.icon, let url = URL(string: "http://openweathermap.org/img/w/\(icon).png") {
                DispatchQueue.global().async {
                    if let image = try? UIImage(data: Data(contentsOf: url, options: Data.ReadingOptions.uncached)) {
                        DispatchQueue.main.async {
                            self?.iconImage.image = image
                        }
                    }
                }
            }
            
            self?.activityIndicator.stopAnimating()
        }
    }
    
    private func cellBackgroundImage(for temp: Double) -> UIImage? {
        switch temp {
        case ...0:
            return #imageLiteral(resourceName: "veryLow")
        case 0..<10:
            return #imageLiteral(resourceName: "low")
        case 10..<20:
            return #imageLiteral(resourceName: "mid")
        case 20...50:
            return #imageLiteral(resourceName: "high")
        default:
            return nil
        }
    }
    
    private func backgroundColor(for temp: Double) -> UIColor {
        switch temp {
        case ...0:
            return UIColor(red: 31/255, green: 38/255, blue: 45/255, alpha: 1)
        case 0..<10:
            return UIColor(red: 129/255, green: 143/255, blue: 157/255, alpha: 1)
        case 10..<20:
            return UIColor(red: 97/255, green: 153/255, blue: 197/255, alpha: 1)
        case 20...50:
            return UIColor(red: 70/255, green: 138/255, blue: 184/255, alpha: 1)
        default:
            return .lightGray
        }
    }
    
    //MARK: - Clean code using ViewModel
    
    private func loadWeatherViewModel() {
        viewManager.getWeatherDetails(cityID: cityID) { [weak self] viewModel in
            DispatchQueue.main.async {
                self?.update(with: viewModel)
            }
        }
    }
    
    private func update(with viewModel: WeatherViewModel) {
        labelCity.text = viewModel.city + ", " + viewModel.detail
        labelTemperature.text = viewModel.temperature
        backgroundImageView.image = viewModel.temperatureCategory.cellBackgroundImage()
        contentView.backgroundColor = viewModel.temperatureCategory.backgroundColor()
        DispatchQueue.global().async {
            if let url = viewModel.icon, let image = try? UIImage(data: Data(contentsOf: url, options: Data.ReadingOptions.uncached)) {
                DispatchQueue.main.async { [weak self] in
                    self?.iconImage.image = image
                }
            }
        }
    }
}
