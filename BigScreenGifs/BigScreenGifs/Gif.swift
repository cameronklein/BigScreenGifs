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
    
    // MARK: - Initializers
    
    init(id: String, description: String?, url: NSURL, size: CGSize) {
        self.id             = id
        self.description    = description
        self.url            = url
        self.size           = size
        
        self.asset = AVAsset(URL: url)
    }
    
    enum GifError : ErrorType {
        case NoID, NoSize, NoType, NoUrl, WrongType, invalidURL
    }
    
    convenience init(json: NSDictionary) throws {
        
        guard let id        = json["id"]    as? String  else { throw GifError.NoID }
        guard let width     = json["width"] as? CGFloat else { throw GifError.NoSize }
        guard let height    = json["width"] as? CGFloat else { throw GifError.NoSize }
        guard let type      = json["type"]  as? String  else { throw GifError.NoType }
        guard let urlString = json["mp4"]   as? String  else { throw GifError.NoUrl }
        
        guard let url = NSURL(string: urlString)        else { throw GifError.invalidURL }
        
        guard type == "image/gif" else { throw GifError.WrongType }
        
        let description = json["description"] as? String
        
        self.init(id: id, description: description, url: url, size: CGSizeMake(width, height))
    }

    class func gifsFromGalleryDictionary(json: NSDictionary) -> [Gif] {
        
        var array = [Gif]()
        
        guard let images = json["data"] as? [NSDictionary] else { return array }
        
        for image in images {
            do {
                let gif = try Gif(json: image)
                array.append(gif)
            } catch GifError.NoID {
                print("Gif Initialization Error: No ID!")
            } catch GifError.NoSize {
                print("Gif Initialization Error: No Size!")
            } catch GifError.NoType {
                print("Gif Initialization Error: No Type!")
            } catch GifError.NoUrl {
                print("Gif Initialization Error: No URL!")
            } catch GifError.WrongType {
                print("Gif Initialization Error: Wrong Type!")
            } catch GifError.invalidURL {
                print("Gif Initialization Error: Invalid URL!")
            } catch {
                print("Something went very wrong")
            }
        }
        return array
    }

}
