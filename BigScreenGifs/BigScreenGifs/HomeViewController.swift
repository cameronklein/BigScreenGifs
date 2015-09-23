//
//  HomeViewController.swift
//  BigScreenGifs
//
//  Created by Cameron Klein on 9/19/15.
//  Copyright © 2015 Cameron Klein. All rights reserved.
//

import UIKit
import AVKit

let interitemSpacing : CGFloat = 48
let sectionInset : CGFloat = 20
let cellsPerRow : CGFloat = 5

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    let dataSource = GifsDataSource()

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
        collectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return itemSize
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.performBatchUpdates({ () -> Void in
            self.collectionView.collectionViewLayout.invalidateLayout()
        }, completion: nil)
        
    }

    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return interitemSpacing
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return interitemSpacing
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(sectionInset, sectionInset, 0, sectionInset)
    }
}

