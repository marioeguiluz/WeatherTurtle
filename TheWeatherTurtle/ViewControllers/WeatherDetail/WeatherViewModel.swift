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

    func cellBackgroundImage() -> UIImage? {
        switch self {
        case .veryLow:
            return #imageLiteral(resourceName: "veryLow")
        case .low:
            return #imageLiteral(resourceName: "low")
        case .mid:
            return #imageLiteral(resourceName: "mid")
        case .high:
            return #imageLiteral(resourceName: "high")
        default:
            return nil
        }
    }
    
    func backgroundColor() -> UIColor {
        switch self {
        case .veryLow:
            return UIColor(red: 31/255, green: 38/255, blue: 45/255, alpha: 1)
        case .low:
            return UIColor(red: 129/255, green: 143/255, blue: 157/255, alpha: 1)
        case .mid:
            return UIColor(red: 97/255, green: 153/255, blue: 197/255, alpha: 1)
        case .high:
            return UIColor(red: 70/255, green: 138/255, blue: 184/255, alpha: 1)
        default:
            return .lightGray
        }
    }
}
