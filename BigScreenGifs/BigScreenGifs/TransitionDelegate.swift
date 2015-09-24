//
//  Wireframe.swift
//  BigScreenGifs
//
//  Created by Cameron Klein on 9/23/15.
//  Copyright © 2015 Cameron Klein. All rights reserved.
//

import UIKit

class TransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if presenting.isKindOfClass(HomeViewController.self) {
            return GroupToSingleTransition()
        } else {
            return GroupToSingleTransition()
        }
    }
}
