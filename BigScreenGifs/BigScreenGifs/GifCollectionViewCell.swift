//
//  GifCollectionViewCell.swift
//  BigScreenGifs
//
//  Created by Cameron Klein on 9/19/15.
//  Copyright © 2015 Cameron Klein. All rights reserved.
//

import UIKit
import AVKit

let cellPopAnimationDuration : NSTimeInterval = 0.2
let cellPopAnimationScale : CGFloat = 1.15

class GifCollectionViewCell: UICollectionViewCell {

    // MARK: - Constants
    let popTransform = CGAffineTransformMakeScale(cellPopAnimationScale, cellPopAnimationScale)
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

            NSNotificationCenter.defaultCenter().addObserver(self,
                selector: "itemDidEnd:",
                name: AVPlayerItemDidPlayToEndTimeNotification,
                object: playerItem)
        }
    }

    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        playerLayer.player = player
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspect
        contentView.layer.addSublayer(playerLayer)
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOffset = CGSizeMake(0, 0)
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.5
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = contentView.bounds
    }
    
    // MARK: - Animation Methods
    
    func pop() {
        self.transform = self.popTransform
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSizeMake(0, 10)
    }
    
    func unpop() {
        self.transform = CGAffineTransformIdentity
        self.layer.shadowOpacity = 0.0
        self.layer.shadowOffset = CGSizeMake(0, 0)
    }
    
    // MARK: - Notification Handlers
    
    func itemDidEnd(sender: NSNotification) {
        playerItem.seekToTime(kCMTimeZero)
        player.play()
    }
    
}
