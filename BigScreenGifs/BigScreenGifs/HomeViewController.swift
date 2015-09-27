//
//  HomeViewController.swift
//  BigScreenGifs
//
//  Created by Cameron Klein on 9/19/15.
//  Copyright © 2015 Cameron Klein. All rights reserved.
//

import UIKit
import AVKit

let interitemSpacing        : CGFloat           = 0
let sectionInset            : CGFloat           = 1000
let offscreenDistance       : CGFloat           = -500
let cellAnimationDuration   : NSTimeInterval    = 0.6

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Constant Properties
    let dataSource = GifsDataSource()
    let labelTransform = CGAffineTransformMakeTranslation(0, 125)

    // MARK: - Variable Properties
    var selectedIndexPath : NSIndexPath!
    
    lazy var itemSize : CGSize = {
        let width = max(0, (self.collectionView.frame.size.width + (offscreenDistance * 2)) * 0.5)
        let height = max(0, self.collectionView.frame.size.height * 0.9)
        
        return CGSize(width: width, height: height)
    }()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewTrailingConstraint.constant = offscreenDistance
        collectionViewLeadingConstraint.constant = offscreenDistance
        
        collectionView.registerClass(GifCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        
        dataSource.loadGifsWithCompletionHandler {
            self.collectionView.reloadData()
        }
        
        descriptionLabel.transform = labelTransform
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return itemSize
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let singleGif = storyboard.instantiateViewControllerWithIdentifier("Single Gif") as! SingleGifViewController
        
        let selectedCell = collectionView.cellForItemAtIndexPath(indexPath) as? GifCollectionViewCell
        selectedIndexPath = indexPath
        singleGif.gif = selectedCell?.gif
        
        singleGif.modalPresentationStyle = .Custom
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        singleGif.transitioningDelegate = appDelegate.transitionDelegate
        self.presentViewController(singleGif, animated: true, completion: nil)
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        cell.transform = CGAffineTransformMakeScale(0.5, 0.5)
    }

    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return interitemSpacing
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return interitemSpacing
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, sectionInset, 0, sectionInset)
    }
    
    
    // MARK: - Focus Engine
    
    func collectionView(collectionView: UICollectionView, didUpdateFocusInContext context: UICollectionViewFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        
        let focusedIndexPath = context.nextFocusedIndexPath
        let nextCell = context.nextFocusedView as? GifCollectionViewCell
        let lastCell = context.previouslyFocusedView as? GifCollectionViewCell
        
        lastCell?.player.pause()
        nextCell?.player.play()
        
        let animations = {
            
            self.collectionView.scrollToItemAtIndexPath(context.nextFocusedIndexPath,
                atScrollPosition: .CenteredHorizontally,
                animated: false)
            
            for i in -3...3 {
                let item = focusedIndexPath.item + i
                let indexPath = NSIndexPath(forItem: item, inSection: 0)
                let cell = collectionView.cellForItemAtIndexPath(indexPath) as? GifCollectionViewCell
                
                let absolute = CGFloat(abs(i))
                let scale = max(0.05, 1.0 - 0.45 * absolute)
                let shadowDistance = max(0, 10 - 8 * absolute)
                
                cell?.transform = CGAffineTransformMakeScale(scale, scale)
                cell?.layer.shadowOffset = CGSize(width: 0, height: shadowDistance)
            }
            
            
        }
        
        UIView.animateWithDuration(cellAnimationDuration,
            delay: 0.0,
            options: .CurveEaseInOut,
            animations: animations,
            completion: nil)
        
        UIView.animateWithDuration(cellAnimationDuration * 0.4,
            delay: 0.0,
            options: .CurveEaseIn,
            animations: { () -> Void in
                self.descriptionLabel.transform = self.labelTransform
            
            }) { (success) -> Void in
                self.descriptionLabel.text = nextCell?.gif.description
                
                UIView.animateWithDuration(cellAnimationDuration * 0.4,
                    delay: 0.0,
                    options: .CurveEaseIn,
                    animations: { () -> Void in
                        self.descriptionLabel.transform = CGAffineTransformIdentity
                        
                }, completion: nil)
        }
    }
    
}

