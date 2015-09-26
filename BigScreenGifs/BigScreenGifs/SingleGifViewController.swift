//
//  SecondViewController.swift
//  BigScreenGifs
//
//  Created by Cameron Klein on 9/19/15.
//  Copyright © 2015 Cameron Klein. All rights reserved.
//

import UIKit
import AVKit

class SingleGifViewController: UIViewController {

    @IBOutlet weak var gifContainerView: UIView!
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var playerLayer : AVPlayerLayer!
    var playerItem : AVPlayerItem!
    
    var gif : Gif! {
        didSet {
            if titleLabel != nil {
                titleLabel.text = gif.description
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = gif.description
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        playerLayer.player?.play()
    }


}

