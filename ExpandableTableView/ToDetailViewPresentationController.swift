//
//  ToDetailViewPresentationController.swift
//  ExpandableTableView
//
//  Created by Vesza Jozsef on 27/05/15.
//  Copyright (c) 2015 Vesza Jozsef. All rights reserved.
//

import UIKit

class ToDetailViewPresentationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! TableViewController
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! DetailViewController
        let finalFrame = transitionContext.finalFrame(for: toViewController)
        let containerView = transitionContext.containerView
        
        toViewController.view.frame = fromViewController.buttonRect!
        toViewController.view.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        toViewController.view.alpha = 0
        containerView.addSubview(toViewController.view)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
            animations: {
                toViewController.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                toViewController.view.frame = finalFrame
                toViewController.view.alpha = 1
            }, completion: { finished in
                transitionContext.completeTransition(true)
        }) 
    }
}
