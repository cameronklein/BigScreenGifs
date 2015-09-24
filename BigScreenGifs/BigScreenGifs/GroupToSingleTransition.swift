//
//  GroupToSingleTransition.swift
//  BigScreenGifs
//
//  Created by Cameron Klein on 9/23/15.
//  Copyright © 2015 Cameron Klein. All rights reserved.
//

import UIKit

class GroupToSingleTransition : NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 1.0
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as? HomeViewController else {
            return
        }
        guard let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as? SingleGifViewController else {
            return
        }
        guard let selectedCell = fromVC.collectionView.cellForItemAtIndexPath(fromVC.selectedIndexPath) else {
            return
        }
        guard let containerView = transitionContext.containerView() else {
            return
        }
        
        print(selectedCell.frame)
        let oldFrame = containerView.convertRect(selectedCell.frame, fromView: fromVC.collectionView)
        print(oldFrame)
        
        containerView.addSubview(toVC.view)
        toVC.view.alpha = 0.0
        toVC.view.layoutSubviews()
        
        containerView.addSubview(selectedCell)
        selectedCell.frame = oldFrame
        
        UIView.animateWithDuration(0.6, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            selectedCell.frame = toVC.gifContainerView.frame
            toVC.view.alpha = 1.0
            }) { (success) -> Void in
                transitionContext.completeTransition(true)
        }
        
    }
    
}
