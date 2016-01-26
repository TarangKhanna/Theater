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
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var infoDescriptionView: UIView!
    
    @IBOutlet weak var infoVideo: YouTubePlayerView!
    
    
    var movies: [NSDictionary]?
    var YouTubeId:Int? = 0
    var movie: NSDictionary!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // set poster image
        
        self.navigationController!.navigationBar.translucent = true
        self.navigationController!.view.backgroundColor = UIColor.clearColor()
        
        let title = movie["title"] as? String
        let overview = movie["overview"] as? String
        YouTubeId = movie["id"] as? Int
        descriptionText.text = overview
        titleLabel.text = title
        if let posterPath = movie["poster_path"] as? String {
            let baseUrlSmall = "https://image.tmdb.org/t/p/w45"
            let baseUrlLarge = "https://image.tmdb.org/t/p/original"
            let smallImageRequest = NSURLRequest(URL: NSURL(string: baseUrlSmall+posterPath)!)
            let largeImageRequest = NSURLRequest(URL: NSURL(string: baseUrlLarge+posterPath)!)
            
            self.posterImageView.setImageWithURLRequest(
                smallImageRequest,
                placeholderImage: nil,
                success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                    
                    // smallImageResponse will be nil if the smallImage is already available
                    // in cache (might want to do something smarter in that case).
                    self.posterImageView.alpha = 0.0
                    self.posterImageView.image = smallImage;
                    
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        
                        self.posterImageView.alpha = 1.0
                        
                        }, completion: { (sucess) -> Void in
                            
                            // The AFNetworking ImageView Category only allows one request to be sent at a time
                            // per ImageView. This code must be in the completion block.
                            self.posterImageView.setImageWithURLRequest(
                                largeImageRequest,
                                placeholderImage: smallImage,
                                success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                                    
                                    self.posterImageView.image = largeImage;
//                                    self.navigationController.navigationBar.setBackgroundImage(largeImage,
//                                        forBarMetrics: .Default)
                                },
                                failure: { (request, response, error) -> Void in
                                    // do something for the failure condition of the large image request
                                    // possibly setting the ImageView's image to a default image
                            })
                    })
                },
                failure: { (request, response, error) -> Void in
                    // do something for the failure condition
                    // possibly try to get the large image
                    self.posterImageView.image = UIImage(named: "no_image.png")
            })
        }
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
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoVideo.frame.origin.y + infoVideo.frame.size.height) // how to access y coordinate of a view?api changed
//        descriptionText.sizeToFit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
