//
//  TransitionAnimation.swift
//  TFS Chat
//
//  Created by dmitry on 26.11.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import UIKit

class TransitionAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    let duration = 1.5
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let toView = transitionContext.view(forKey: .to) else { return }
        let initialFrame = CGRect.zero
        let finalFrame = toView.frame
        let xScaleFactor = initialFrame.width / finalFrame.width
        let yScaleFactor = initialFrame.height / finalFrame.height
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        toView.transform = scaleTransform
        containerView.addSubview(toView)
        
        UIView.animate(
            withDuration: duration,
            delay: 0.0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.2,
            animations: {
                toView.transform = .identity
            }, completion: { _ in
                transitionContext.completeTransition(true)
            })
    }
    
}
