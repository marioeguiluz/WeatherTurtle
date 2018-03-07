//
//  WeatherMapManager.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 27/02/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

import MapKit

protocol WeatherMapManagerDelegate: class {
    func weatherMapManager(_ weatherMapManager: WeatherMapManager, didSelect weatherViewModel: WeatherViewModel)
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
        mapView.register(WeatherAnnotationView.self, forAnnotationViewWithReuseIdentifier: WeatherAnnotationView.identifier)
        mapView.register(WeatherClusterView.self, forAnnotationViewWithReuseIdentifier: WeatherClusterView.identifier)
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

        if annotation is WeatherPointAnnotation {
            let annotationView: WeatherAnnotationView
            if let reusableAnnotation = mapView.dequeueReusableAnnotationView(withIdentifier: WeatherAnnotationView.identifier) as? WeatherAnnotationView {
                annotationView = reusableAnnotation
                annotationView.annotation = annotation
            } else {
                annotationView = WeatherAnnotationView(annotation: annotation, reuseIdentifier: WeatherAnnotationView.identifier)
            }
            return annotationView

        } else if annotation is MKClusterAnnotation {
            let annotationView: WeatherClusterView
            if let reusableAnnotation = mapView.dequeueReusableAnnotationView(withIdentifier: WeatherClusterView.identifier) as? WeatherClusterView {
                annotationView = reusableAnnotation
                annotationView.annotation = annotation
            } else {
                annotationView = WeatherClusterView(annotation: annotation, reuseIdentifier: WeatherClusterView.identifier)
            }
            return annotationView
        } else {
            return nil
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? WeatherPointAnnotation, let delegate = delegate {
            delegate.weatherMapManager(self, didSelect: annotation.weatherModel)
        }
    }
}
