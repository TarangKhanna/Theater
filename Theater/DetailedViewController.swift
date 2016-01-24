//
//  DetailedViewController.swift
//  Theater
//
//  Created by Tarang khanna on 1/16/16.
//  Copyright © 2016 Tarang khanna. All rights reserved.
//

import UIKit
import YouTubePlayer

class DetailedViewController: UIViewController {
    
    @IBOutlet var videoPlayer: YouTubePlayerView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionText: UITextView!
    
    
    var movies: [NSDictionary]?
    var descriptionPassed:String = ""
    var titlePassed:String? = ""
    var YouTubeId:Int? = 0
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        descriptionText.text = descriptionPassed
        titleLabel.text = titlePassed
        retrieve()
    }
    
    func retrieve() {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/\(YouTubeId!)/videos?api_key=\(apiKey)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if error != nil{
                }
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            self.movies = responseDictionary["results"] as? [NSDictionary]
                            if ((self.movies?.isEmpty) == false) {
                                if let videoId = self.movies![0]["key"] as? String {
                                    
                                    self.videoPlayer.loadVideoID(videoId)
                                }
                            }
                    }
                }
        });
        task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
