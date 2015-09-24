//
//  NetworkController.swift
//  BigScreenVideos
//
//  Created by Cameron Klein on 9/15/15.
//  Copyright © 2015 Cameron Klein. All rights reserved.
//

import UIKit

class NetworkController {
    
    static let baseURL = "https://api.imgur.com/3/"
    
    class func getGifsWithSuccessHandler(successHandler: (gifs: [Gif]) -> (Void), failureHandler:(errorDescription: String) -> (Void))
    {
        let urlString = baseURL + "gallery/search/viral/0?q=cat&q_type=anigif"
        let url = NSURL(string: urlString)
        
        guard let requestURL = url else {
            failureHandler(errorDescription: "URL failed")
            return
        }
        
        let request = NSMutableURLRequest(URL: requestURL)
        request.setValue("Client-ID " + imgurClientID, forHTTPHeaderField: "Authorization")
        
        let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
            
            if let myError = error {
                failureHandler(errorDescription: myError.description)
                return
            }
            
            guard let myResponse = response as? NSHTTPURLResponse else {
                failureHandler(errorDescription: "No response")
                return
            }

            switch myResponse.statusCode {
            case 200...299:
                
                guard let myData = data else {
                    failureHandler(errorDescription: "Data error")
                    return
                }
                
                if let json = try? NSJSONSerialization.JSONObjectWithData(myData, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary {
                    let gifs = Gif.gifsFromGalleryDictionary(json)
                    dispatch_async(dispatch_get_main_queue()) {
                        successHandler(gifs: gifs)
                    }
                }
                
            default:
                failureHandler(errorDescription: "Something went wrong")
            }
        }
        
        dataTask.resume()
    }
    
}
