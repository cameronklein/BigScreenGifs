//
//  GifsDataSource.swift
//  BigScreenGifs
//
//  Created by Cameron Klein on 9/19/15.
//  Copyright © 2015 Cameron Klein. All rights reserved.
//

import UIKit
import AVKit

class GifsDataSource: NSObject, UICollectionViewDataSource {
    
    var gifs : [Gif] = [Gif]()
    
    func loadGifsWithCompletionHandler(completionHandler: Void -> Void) {
        
        NetworkController.getGifsWithSuccessHandler({ (gifs) -> (Void) in
            
            self.gifs = gifs
            completionHandler()
            
            }) { (errorDescription) -> (Void) in
                
                print(errorDescription.debugDescription)
                
        }
    }
    // MARK: - UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gifs.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! GifCollectionViewCell
        cell.gif = gifs[indexPath.row]
        return cell
    }
    
    
}
