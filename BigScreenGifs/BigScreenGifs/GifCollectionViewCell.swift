//
//  GifCollectionViewCell.swift
//  BigScreenGifs
//
//  Created by Cameron Klein on 9/19/15.
//  Copyright © 2015 Cameron Klein. All rights reserved.
//

import UIKit
import AVKit

let kCellPopAnimationDuration : NSTimeInterval = 0.2
let kCellPopAnimationScale : CGFloat = 1.2

class GifCollectionViewCell: UICollectionViewCell {

    // MARK: - Constants
    
    let player = AVPlayer()
    let playerLayer = AVPlayerLayer()
    
    // MARK - Variables
    
    var playerItem : AVPlayerItem!
    
    var gif : Gif! {
        willSet {
            NSNotificationCenter.defaultCenter().removeObserver(self, name: AVPlayerItemDidPlayToEndTimeNotification, object: playerItem)
        }
        didSet {
            self.playerItem = AVPlayerItem(asset: gif.asset)
            self.player.replaceCurrentItemWithPlayerItem(self.playerItem)
            self.player.play()
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemDidEnd:", name: AVPlayerItemDidPlayToEndTimeNotification, object: playerItem)
        }
    }

    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        playerLayer.player = player
        contentView.layer.addSublayer(playerLayer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = contentView.bounds
    }
    
    // MARK: - Focus Engine Methods
    
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        
        UIView.animateWithDuration(kCellPopAnimationDuration, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.transform =  self.focused ? CGAffineTransformMakeScale(kCellPopAnimationScale, kCellPopAnimationScale) :CGAffineTransformIdentity

            }) { (success) -> Void in
                
        }
    }
    
    // MARK: - Notification Handlers
    
    func itemDidEnd(sender: NSNotification) {
        playerItem.seekToTime(kCMTimeZero)
        player.play()
    }
    
}