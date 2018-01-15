//
//  BackToMainViewPresentationController.swift
//  ExpandableTableView
//
//  Created by Vesza Jozsef on 27/05/15.
//  Copyright (c) 2015 Vesza Jozsef. All rights reserved.
//

import UIKit

class BackToMainViewPresentationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! DetailViewController
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! TableViewController
        let finalFrame = toViewController.buttonRect!
        let containerView = transitionContext.containerView
        
        containerView.addSubview(toViewController.view)
        containerView.sendSubview(toBack: toViewController.view)
        
        let snapshotView = fromViewController.view.snapshotView(afterScreenUpdates: false)
        snapshotView?.frame = fromViewController.view.frame
        containerView.addSubview(snapshotView!)
        
        fromViewController.view.removeFromSuperview()
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
            animations: {
                snapshotView?.frame = finalFrame
                snapshotView?.alpha = 0
            }, completion: { finished in
                snapshotView?.removeFromSuperview()
                transitionContext.completeTransition(true)
        }) 
    }
}
