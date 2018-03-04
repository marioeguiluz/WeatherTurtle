//
//  WeatherClusterView.swift
//  TheWeatherTurtle
//
//  Created by MARIO EGUILUZ ALEBICTO on 03/03/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//
//  See https://developer.apple.com/videos/play/wwdc2017/237

import MapKit

final class WeatherClusterView: MKAnnotationView {
    static let identifier = "WeatherClusterView"

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        displayPriority = .defaultHigh
        collisionMode = .circle
        centerOffset = CGPoint(x: 0, y: -10)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var annotation: MKAnnotation? {
        willSet {
            if let cluster = newValue as? MKClusterAnnotation {

                let renderer = UIGraphicsImageRenderer(size: CGSize(width: 40, height: 40))
                let count = cluster.memberAnnotations.count

                let veryLowCount = cluster.memberAnnotations.filter { member -> Bool in
                    if let model = member as? WeatherPointAnnotation {
                        return model.category == .veryLow
                    } else {
                        return false
                    }
                    }.count

                let lowCount = cluster.memberAnnotations.filter { member -> Bool in
                    if let model = member as? WeatherPointAnnotation {
                        return model.category == .low
                    } else {
                        return false
                    }
                    }.count

                let midCount = cluster.memberAnnotations.filter { member -> Bool in
                    if let model = member as? WeatherPointAnnotation {
                        return model.category == .mid
                    } else {
                        return false
                    }
                    }.count

                let highCount = cluster.memberAnnotations.filter { member -> Bool in
                    if let model = member as? WeatherPointAnnotation {
                        return model.category == .high
                    } else {
                        return false
                    }
                    }.count

                image = renderer.image { _ in
                    // Fill full circle with tricycle color
                    TemperatureCategory.veryLow.pinColor().setFill()
                    //UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 40, height: 40)).fill()
                    let piePathVeryLow = UIBezierPath()
                    let veryLowAngle = (CGFloat.pi * 2.0 * CGFloat(veryLowCount)) / CGFloat(count)
                    piePathVeryLow.addArc(withCenter: CGPoint(x: 20, y: 20), radius: 20,
                                   startAngle: 0, endAngle: veryLowAngle,
                                   clockwise: true)
                    piePathVeryLow.addLine(to: CGPoint(x: 20, y: 20))
                    piePathVeryLow.close()
                    piePathVeryLow.fill()

                    // Fill pie with unicycle color
                    TemperatureCategory.low.pinColor().setFill()
                    let piePath = UIBezierPath()
                    let lowAngle = veryLowAngle + (CGFloat.pi * 2.0 * CGFloat(lowCount)) / CGFloat(count)
                    piePath.addArc(withCenter: CGPoint(x: 20, y: 20), radius: 20,
                                   startAngle: veryLowAngle, endAngle: lowAngle,
                                   clockwise: true)
                    piePath.addLine(to: CGPoint(x: 20, y: 20))
                    piePath.close()
                    piePath.fill()

                    // Fill pie with unicycle color
                    TemperatureCategory.mid.pinColor().setFill()
                    let piePathMid = UIBezierPath()
                    let midAngle = lowAngle + (CGFloat.pi * 2.0 * CGFloat(midCount)) / CGFloat(count)
                    piePathMid.addArc(withCenter: CGPoint(x: 20, y: 20), radius: 20,
                                   startAngle: lowAngle, endAngle: midAngle,
                                   clockwise: true)
                    piePathMid.addLine(to: CGPoint(x: 20, y: 20))
                    piePathMid.close()
                    piePathMid.fill()

                    // Fill pie with unicycle color
                    TemperatureCategory.high.pinColor().setFill()
                    let piePathHigh = UIBezierPath()
                    let highAngle = midAngle + (CGFloat.pi * 2.0 * CGFloat(highCount)) / CGFloat(count)
                    piePathHigh.addArc(withCenter: CGPoint(x: 20, y: 20), radius: 20,
                                   startAngle: midAngle, endAngle: highAngle,
                                   clockwise: true)
                    piePathHigh.addLine(to: CGPoint(x: 20, y: 20))
                    piePathHigh.close()
                    piePathHigh.fill()

                    // Fill inner circle with white color
                    UIColor.white.setFill()
                    UIBezierPath(ovalIn: CGRect(x: 8, y: 8, width: 24, height: 24)).fill()

                    // Finally draw count text vertically and horizontally centered
                    let attributes = [ NSAttributedStringKey.foregroundColor: UIColor.black,
                                       NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 20)]
                    let text = "\(count)"
                    let size = text.size(withAttributes: attributes)
                    let rect = CGRect(x: 20 - size.width / 2, y: 20 - size.height / 2, width: size.width, height: size.height)
                    text.draw(in: rect, withAttributes: attributes)
                }
            }
        }
    }
}
