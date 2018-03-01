//
//  WeatherMapDataManager.swift
//  TheWeatherTurtle
//
//  Created by MARIO EGUILUZ ALEBICTO on 01/03/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

import MapKit

final class WeatherMapDataManager {
    private let locationService: LocationService

    init(locationService: LocationService) {
        self.locationService = locationService
    }

    func getCity(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (_ city: String?, _ error: Error?) -> ()) {
        locationService.getCity(latitude: latitude, longitude: longitude, completion: completion)
    }
}
