//
//  LocationService.swift
//  TheWeatherTurtle
//
//  Created by MARIO EGUILUZ ALEBICTO on 01/03/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

import MapKit

final class LocationService {

    private let geoCoder = CLGeocoder()

    func getCity(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (_ city: String?, _ error: Error?) -> ()) {

        let location = CLLocation(latitude: latitude, longitude: longitude)
        geoCoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                completion(nil, error)
            } else {
                guard let address = placemarks?.first?.name else {
                    return
                }
                completion(address, nil)
            }
        }
    }
}
