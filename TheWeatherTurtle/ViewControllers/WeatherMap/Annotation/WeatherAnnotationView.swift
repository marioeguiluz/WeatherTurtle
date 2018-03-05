//
//  WeatherAnnotationView.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 05/03/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

import MapKit

final class WeatherAnnotationView: MKMarkerAnnotationView {
    static let identifier = "WeatherAnnotationView"
    override var annotation: MKAnnotation? {
        willSet {
            if let viewModel = newValue as? WeatherPointAnnotation {
                clusteringIdentifier = WeatherClusterView.identifier
                markerTintColor = viewModel.pinColor
                displayPriority = .defaultLow
            }
        }
    }
}
