//
//  WeatherMapManager.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 27/02/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

import MapKit

protocol WeatherMapManagerDelegate: class {
    
}

final class WeatherMapManager: NSObject {
    
    private weak var delegate: WeatherMapManagerDelegate?
    private let mapView: MKMapView
    private var items: [WeatherViewModel] = []
    
    init(mapView: MKMapView, delegate: WeatherMapManagerDelegate) {
        self.mapView = mapView
        self.delegate = delegate
    }
    
    func prepareMapView() {
        mapView.mapType = .mutedStandard
        mapView.delegate = self
        mapView.register(WeatherAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    }
    
    func reload(with items: [WeatherViewModel]) {
        self.items = items
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(items.map(WeatherPointAnnotation.init))
    }

    func addAnnotation(_ weatherViewModel: WeatherViewModel) {
        items.append(weatherViewModel)
        mapView.addAnnotation(WeatherPointAnnotation(weatherModel: weatherViewModel))
    }
}

extension WeatherMapManager: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return nil
    }
}
