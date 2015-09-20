//
//  Gif.swift
//  BigScreenGifs
//
//  Created by Cameron Klein on 9/19/15.
//  Copyright © 2015 Cameron Klein. All rights reserved.
//

import UIKit
import AVKit

class Gif {
    
    let id              : String
    let description     : String?
    let url             : NSURL
    let size            : CGSize
    let asset           : AVAsset
    
    init(id: String, description: String?, url: NSURL, size: CGSize) {
        self.id             = id
        self.description    = description
        self.url            = url
        self.size           = size
        
        self.asset = AVAsset(URL: url)
    }
    
    class func gifsFromGalleryDictionary(json: NSDictionary) -> [Gif] {
        
        var array = [Gif]()
        
        guard let images = json["data"] as? NSArray else {
            return array
        }

        for image in images {
            
            guard let id = image["id"] as? String else { break }
            let description = image["description"] as? String
            guard let width = image["width"] as? Int else { break }
            guard let height = image["width"] as? Int else { break }
            guard let type = image["type"] as? String else { break }
            guard type == "image/gif" else { break }
            guard let urlString = image["mp4"] as? String else { break }
            
            let widthNumber = NSNumber(integer: width)
            let heightNumber = NSNumber(integer: height)
            
            let CGWidth = CGFloat(widthNumber)
            let CGHeight = CGFloat(heightNumber)
            
            let httpsString = urlString.stringByReplacingOccurrencesOfString("http", withString: "https")
            guard let url = NSURL(string: httpsString) else { break }

            array.append(Gif(id: id, description: description, url: url, size: CGSizeMake(CGWidth, CGHeight)))
        }
        
        return array

    }

}
