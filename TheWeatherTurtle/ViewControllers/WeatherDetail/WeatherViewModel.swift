//
//  WeatherViewModel.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 07/02/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

import Foundation
import UIKit

struct WeatherViewModel {
    let id: String
    let city: String
    let temperature: String
    let temperatureCategory: TemperatureCategory
    let detail: String
    let longitude: Double
    let latitude: Double
    let icon: URL?
}

extension WeatherViewModel {
    
    init?(with data: WeatherDetails?) {
        guard
            let cityID = data?.id,
            let cityName = data?.name,
            let temp = data?.main?.temp,
            let details = data?.weather?.first?.description,
            let iconName = data?.weather?.first?.icon,
            let lat = data?.coord?.lat,
            let long = data?.coord?.lon else {
                return nil
        }
        
        id = "\(cityID)"
        city = cityName
        temperature = String(format: "%.0f", temp.rounded(.toNearestOrEven)) + "°"
        temperatureCategory = TemperatureCategory(with: temp)
        detail = details
        latitude = lat
        longitude = long
        icon = WeatherViewModel.weatherIconURL(for: iconName)
    }
    
    static func empty() -> WeatherViewModel {
        return WeatherViewModel(id: "0", city: "No city", temperature: "No data", temperatureCategory: .unknown, detail: "No details", longitude: 0, latitude: 0, icon: nil)
    }

    private static func weatherIconURL(for code: String) -> URL? {
        guard let url = URL(string: "http://openweathermap.org/img/w/\(code).png") else {
            return nil
        }
        return url
    }
}

enum TemperatureCategory {
    case veryLow
    case low
    case mid
    case high
    case unknown
    
    init(with temperature: Double) {
        switch temperature {
        case ...0:
            self = .veryLow
        case 0..<10:
            self = .low
        case 10..<20:
            self = .mid
        case 20...50:
            self = .high
        default:
            self = .unknown
        }
    }
    
    func backgroundImage() -> UIImage? {
        switch self {
        case .veryLow:
            return #imageLiteral(resourceName: "verycold")
        case .low:
            return #imageLiteral(resourceName: "cold")
        case .mid:
            return #imageLiteral(resourceName: "sunny")
        case .high:
            return #imageLiteral(resourceName: "hot")
        default:
            return nil
        }
    }
    
    func backgroundColor() -> UIColor {
        switch self {
        case .veryLow:
            return UIColor(red: 86/255, green: 189/255, blue: 224/255, alpha: 1.0)
        case .low:
            return UIColor(red: 113/255, green: 87/255, blue: 245/255, alpha: 1.0)
        case .mid:
            return UIColor(red: 126/255, green: 215/255, blue: 157/255, alpha: 1.0)
        case .high:
            return UIColor(red: 213/255, green: 96/255, blue: 123/255, alpha: 1.0)
        default:
            return .groupTableViewBackground
        }
    }
    
    func textColor() -> UIColor {
        return self == .veryLow ? .darkGray : .white
    }
}
