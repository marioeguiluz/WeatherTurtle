//
//  WeatherViewModel.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 28/04/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

import Foundation
import UIKit

struct WeatherViewModel {
    let temperature: String
    let iconUrl: URL
    let cityAndDetails: String
    let backgroundColor: UIColor
    let cellBackgroundImage: UIImage?
    
    init?(with data: WeatherDetails?) {
        guard let cityName = data?.name,
            let weatherDescription = data?.weather?.first?.description,
            let temp = data?.main?.temp,
            let icon = data?.weather?.first?.icon,
            let url = URL(string: "http://openweathermap.org/img/w/\(icon).png") else {
                return nil
        }
        
        cityAndDetails = cityName + ", " + weatherDescription
        iconUrl = url
        temperature = String(format: "%.0f", temp.rounded(.toNearestOrEven)) + "°"
        cellBackgroundImage = WeatherViewModel.cellBackgroundImage(for: temp)
        backgroundColor = WeatherViewModel.backgroundColor(for: temp)
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
        // If a new developer changes one of these ranges due to a request...what will happen with the following method? Would the dev notice and do the proper change too?
        // It will be easy to introduce a bug...
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
