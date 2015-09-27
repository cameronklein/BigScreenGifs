//
//  HomeViewController.swift
//  BigScreenGifs
//
//  Created by Cameron Klein on 9/19/15.
//  Copyright © 2015 Cameron Klein. All rights reserved.
//

import UIKit
import AVKit

let interitemSpacing : CGFloat = 100
let sectionInset : CGFloat = 48
let cellsPerRow : CGFloat = 2.2

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Constant Properties
    let dataSource = GifsDataSource()

    // MARK: - Variable Properties
    var selectedIndexPath : NSIndexPath!
    
    lazy var itemSize : CGSize = {
        let numberOfSpaces = cellsPerRow - 1
        let totalSpace = (numberOfSpaces * interitemSpacing) + (sectionInset * 2)
        let width = self.collectionView.frame.size.width
        let dimension = (width - totalSpace) / cellsPerRow
        return CGSize(width: dimension, height: dimension)
    }()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.registerClass(GifCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        dataSource.loadGifsWithCompletionHandler {
            self.collectionView.reloadData()
        }
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
    
    func collectionView(collectionView: UICollectionView, didUpdateFocusInContext context: UICollectionViewFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        
        let lastCell = context.previouslyFocusedView as? GifCollectionViewCell
        let nextCell = context.nextFocusedView as? GifCollectionViewCell
        
        let animations = {
            
            self.collectionView.scrollToItemAtIndexPath(context.nextFocusedIndexPath,
                atScrollPosition: .CenteredHorizontally,
                animated: false)
            
            lastCell?.unpop()
            lastCell?.player.pause()
            nextCell?.pop()
            nextCell?.player.play()
            
        }
        
        UIView.animateWithDuration(0.5,
            delay: 0.0,
            options: UIViewAnimationOptions.AllowAnimatedContent,
            animations: animations,
            completion: nil)
    }

    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return interitemSpacing
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, sectionInset, 0, sectionInset)
    }
    
}

