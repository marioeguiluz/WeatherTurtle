//
//  WeatherViewModel.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 07/05/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

import Foundation
import UIKit

struct WeatherViewModel {
    let cityAndDescription: String
    let temperatureString: String
    let backgroundImage: UIImage?
    let backgroundColor: UIColor?
    let iconURL: URL
    
    init?(weatherDetails: WeatherDetails) {
        guard let name = weatherDetails.name,
            let description = weatherDetails.weather?.first?.description,
            let temp = weatherDetails.main?.temp,
            let icon = weatherDetails.weather?.first?.icon,
            let url = URL(string: "http://openweathermap.org/img/w/\(icon).png") else {
            return nil
        }
        
        cityAndDescription = name + ", " + description
        backgroundImage = WeatherViewModel.cellBackgroundImage(for: temp)
        backgroundColor = WeatherViewModel.backgroundColor(for: temp)
        temperatureString = String(format: "%.0f", temp.rounded(.toNearestOrEven)) + "°"
        iconURL = url
    }
    
    private static func cellBackgroundImage(for temp: Double) -> UIImage? {
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
    
    private static func backgroundColor(for temp: Double) -> UIColor {
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
}
