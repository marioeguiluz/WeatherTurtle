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
                
                var veryLowCount = 0
                var lowCount = 0
                var midCount = 0
                var highCount = 0
                cluster.memberAnnotations.forEach { member in
                    guard let weatherAnnotation = member as? WeatherPointAnnotation else {
                        return
                    }
                    switch weatherAnnotation.category {
                    case .veryLow: veryLowCount += 1
                    case .low: lowCount += 1
                    case .mid: midCount += 1
                    case .high: highCount += 1
                    case .unknown: break
                    }
                }
                
                image = renderer.image { _ in
                    
                    TemperatureCategory.veryLow.pinColor().setFill()
                    let piePathVeryLow = UIBezierPath()
                    let veryLowAngle = (CGFloat.pi * 2.0 * CGFloat(veryLowCount)) / CGFloat(count)
                    piePathVeryLow.addArc(withCenter: CGPoint(x: 20, y: 20), radius: 20,
                                   startAngle: 0, endAngle: veryLowAngle,
                                   clockwise: true)
                    piePathVeryLow.addLine(to: CGPoint(x: 20, y: 20))
                    piePathVeryLow.close()
                    piePathVeryLow.fill()

                    TemperatureCategory.low.pinColor().setFill()
                    let piePath = UIBezierPath()
                    let lowAngle = veryLowAngle + (CGFloat.pi * 2.0 * CGFloat(lowCount)) / CGFloat(count)
                    piePath.addArc(withCenter: CGPoint(x: 20, y: 20), radius: 20,
                                   startAngle: veryLowAngle, endAngle: lowAngle,
                                   clockwise: true)
                    piePath.addLine(to: CGPoint(x: 20, y: 20))
                    piePath.close()
                    piePath.fill()

                    TemperatureCategory.mid.pinColor().setFill()
                    let piePathMid = UIBezierPath()
                    let midAngle = lowAngle + (CGFloat.pi * 2.0 * CGFloat(midCount)) / CGFloat(count)
                    piePathMid.addArc(withCenter: CGPoint(x: 20, y: 20), radius: 20,
                                   startAngle: lowAngle, endAngle: midAngle,
                                   clockwise: true)
                    piePathMid.addLine(to: CGPoint(x: 20, y: 20))
                    piePathMid.close()
                    piePathMid.fill()

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

                    drawTotalAnnotationsText(count)
                }
            }
        }
    }
    
    private func drawColorSections() {
        
    }
    
    private func drawTotalAnnotationsText(_ count: Int) {
        let attributes = [ NSAttributedStringKey.foregroundColor: UIColor.black,
                           NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 20)]
        let text = "\(count)"
        let size = text.size(withAttributes: attributes)
        let rect = CGRect(x: 20 - size.width / 2, y: 20 - size.height / 2, width: size.width, height: size.height)
        text.draw(in: rect, withAttributes: attributes)
    }
}
