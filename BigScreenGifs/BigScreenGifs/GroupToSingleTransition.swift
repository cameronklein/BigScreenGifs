//
//  GroupToSingleTransition.swift
//  BigScreenGifs
//
//  Created by Cameron Klein on 9/23/15.
//  Copyright © 2015 Cameron Klein. All rights reserved.
//

import UIKit
import AVKit

let animationDuration = 0.4

class GroupToSingleTransition : NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 10.0
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as? HomeViewController else {
            return
        }
        guard let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as? SingleGifViewController else {
            return
        }
        guard let selectedCell = fromVC.collectionView.cellForItemAtIndexPath(fromVC.selectedIndexPath) as? GifCollectionViewCell else {
            return
        }
        guard let containerView = transitionContext.containerView() else {
            return
        }
        
        let playerLayer = selectedCell.playerLayer
        toVC.playerLayer = playerLayer
        
        let oldFrame    = fromVC.view.convertRect(selectedCell.frame, fromView: fromVC.collectionView)
        let oldBounds   = CGRect(x: 0, y: 0, width: oldFrame.width, height: oldFrame.height)
        let oldPosition = CGPoint(x: CGRectGetMidX(oldFrame), y: CGRectGetMidY(oldFrame))
        
        let newFrame    = toVC.gifContainerView.frame
        let newBounds   = CGRect(x: 0, y: 0, width: newFrame.width, height: newFrame.height)
        let newPosition = CGPoint(x: CGRectGetMidX(newFrame), y: CGRectGetMidY(newFrame))
        
        containerView.addSubview(toVC.view)
        toVC.coverView.alpha = 0
        
        toVC.view.layer.addSublayer(playerLayer)
        
        playerLayer.frame = newFrame
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspect
        
        
        CATransaction.begin()

        let boundsAnimation = CABasicAnimation(keyPath: "bounds")
        boundsAnimation.fromValue = NSValue(CGRect: oldBounds)
        boundsAnimation.toValue   = NSValue(CGRect: newBounds)
        boundsAnimation.duration  = animationDuration
        
        let positionAnimation = CABasicAnimation(keyPath: "position")
        positionAnimation.fromValue = NSValue(CGPoint: oldPosition)
        positionAnimation.toValue   = NSValue(CGPoint: newPosition)
        positionAnimation.duration  = animationDuration
        
        CATransaction.setCompletionBlock { () -> Void in
            transitionContext.completeTransition(true)
        }
        
        playerLayer.addAnimation(boundsAnimation, forKey: "bounds")
        playerLayer.addAnimation(positionAnimation, forKey: "position")
        
        CATransaction.commit()
        
        
        UIView.animateWithDuration(animationDuration) { () -> Void in
            toVC.coverView.alpha = 0.8
        }
        
    }
    
}
