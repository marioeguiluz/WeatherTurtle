import UIKit

final class Animator: NSObject {
    let duration: TimeInterval = 0.25
    var presenting = true
    var originFrame = CGRect.zero
}

extension Animator: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toView = transitionContext.view(forKey: .to),
            let detailView = presenting ? toView : transitionContext.view(forKey: .from) else { return }
        
        let containerView = transitionContext.containerView

        let initialFrame = presenting ? originFrame : detailView.frame
        let finalFrame = presenting ? detailView.frame : originFrame
        
        let yScaleFactor = presenting ?
            initialFrame.height / finalFrame.height :
            finalFrame.height / initialFrame.height
        
        let scaleTransform = CGAffineTransform(scaleX: 1, y: yScaleFactor)
        
        if presenting {
            detailView.alpha = 0
            detailView.transform = scaleTransform
            detailView.center = CGPoint(
                x: initialFrame.midX,
                y: initialFrame.midY)
            detailView.clipsToBounds = true
        }
        
        containerView.addSubview(toView)
        containerView.bringSubviewToFront(detailView)
        
        UIView.animate(withDuration: duration,
                       animations: {
                        detailView.transform = self.presenting ? CGAffineTransform.identity : scaleTransform
                        detailView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
                        detailView.alpha = 1
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }
}
