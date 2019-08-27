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

                let totalCount = cluster.memberAnnotations.count
                let sections = countCategories(memberAnnotations: cluster.memberAnnotations)
               
                let renderer = UIGraphicsImageRenderer(size: CGSize(width: 40, height: 40))
                image = renderer.image { _ in
                    drawCircleBorderSections(sections, totalCount: totalCount)
                    drawCenter()
                    drawTotalAnnotationsText(totalCount)
                }
            }
        }
    }
    
    private func countCategories(memberAnnotations: [MKAnnotation]) -> [(category: TemperatureCategory, sectionCount: Int)] {
        var veryLowCount = 0
        var lowCount = 0
        var midCount = 0
        var highCount = 0
        
        memberAnnotations.forEach { member in
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
        
        let sections: [(category: TemperatureCategory, sectionCount: Int)] = [
            (.veryLow, sectionCount: veryLowCount),
            (.low, sectionCount: lowCount),
            (.mid, sectionCount: midCount),
            (.high, sectionCount: highCount)]
        
        return sections
    }
    
    private func drawCircleBorderSections(_ sections: [(category: TemperatureCategory, sectionCount: Int)], totalCount: Int) {
        var startingAngle:CGFloat = 0
        for (sectionCategory, sectionCount) in sections {
            sectionCategory.backgroundColor().setFill()
            let piePath = UIBezierPath()
            let endAngle = startingAngle + (CGFloat.pi * 2.0 * CGFloat(sectionCount)) / CGFloat(totalCount)
            piePath.addArc(withCenter: CGPoint(x: 20, y: 20), radius: 20,
                           startAngle: startingAngle, endAngle: endAngle,
                           clockwise: true)
            piePath.addLine(to: CGPoint(x: 20, y: 20))
            piePath.close()
            piePath.fill()
            startingAngle = endAngle
        }
    }
    
    private func drawCenter() {
        UIColor.white.setFill()
        UIBezierPath(ovalIn: CGRect(x: 8, y: 8, width: 24, height: 24)).fill()
    }
    
    private func drawTotalAnnotationsText(_ count: Int) {
        let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.black,
                           NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        let text = "\(count)"
        let size = text.size(withAttributes: attributes)
        let rect = CGRect(x: 20 - size.width / 2, y: 20 - size.height / 2, width: size.width, height: size.height)
        text.draw(in: rect, withAttributes: attributes)
    }
}
