//
//  WeatherPointAnnotation.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 27/02/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

import MapKit

final class WeatherPointAnnotation: MKPointAnnotation {
    
    let weatherModel: WeatherViewModel
    var pinColor: UIColor {
        return weatherModel.temperatureCategory.pinColor()
    }
    var category: TemperatureCategory {
        return weatherModel.temperatureCategory
    }
    
    init(weatherModel: WeatherViewModel) {
        self.weatherModel = weatherModel
        super.init()
        coordinate = CLLocationCoordinate2D(latitude: weatherModel.latitude, longitude: weatherModel.longitude)
        title = weatherModel.city + " " + weatherModel.temperature
        subtitle = weatherModel.detail
    }
}
