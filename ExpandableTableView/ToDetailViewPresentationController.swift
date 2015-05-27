//
//  ToDetailViewPresentationController.swift
//  ExpandableTableView
//
//  Created by Vesza Jozsef on 27/05/15.
//  Copyright (c) 2015 Vesza Jozsef. All rights reserved.
//

import UIKit

class ToDetailViewPresentationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! TableViewController
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! DetailViewController
        let finalFrame = transitionContext.finalFrameForViewController(toViewController)
        let containerView = transitionContext.containerView()

        let xScale = fromViewController.buttonRect!.width / finalFrame.width
        let yScale = fromViewController.buttonRect!.height / finalFrame.height
        
        toViewController.view.frame.origin = fromViewController.buttonRect!.origin
        toViewController.view.transform = CGAffineTransformMakeScale(xScale, yScale)
        containerView.addSubview(toViewController.view)
        
        UIView.animateWithDuration(transitionDuration(transitionContext),
            animations: {
                toViewController.view.transform = CGAffineTransformIdentity
                toViewController.view.frame.origin = finalFrame.origin
            }) { (finished) -> Void in
                transitionContext.completeTransition(true)
        }
    }
}
