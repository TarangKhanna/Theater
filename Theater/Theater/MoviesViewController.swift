//
//  MoviesViewController.swift
//  Theater
//
//  Created by Tarang khanna on 1/13/16.
//  Copyright © 2016 Tarang khanna. All rights reserved.
//

import UIKit
import AFNetworking
import DGElasticPullToRefresh
import RJImageLoader
import SwiftSpinner
import DGActivityIndicatorView

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var offlineImage: UIImageView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var movies: [NSDictionary]?
    var searchActive : Bool = false
    var filtered:[NSDictionary] = []
    let activityIndicatorView = DGActivityIndicatorView(type: DGActivityIndicatorAnimationType.FiveDots, tintColor: UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0), size: 70.0)
    
    override func viewWillAppear(animated: Bool) {
        self.view.backgroundColor = UIColor(red: 221/255.0, green: 221/255.0, blue: 221/255.0, alpha: 1)
        statusLabel.hidden = true
        offlineImage.hidden = true
        searchActive = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        searchActive = false
        searchBar.delegate = self
        searchBar.endEditing(true)
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 75, 0)
        activityIndicatorView.center = self.view.center
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        self.tableView.backgroundColor = UIColor.clearColor()
        retrieve()
        
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            self!.retrieve()
            self?.tableView.dg_stopLoading()
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
        tableView.dataSource = self
        tableView.delegate = self
    }

    func retrieve() {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if error != nil{
                    self.view.bringSubviewToFront(self.offlineImage)
                    self.view.bringSubviewToFront(self.statusLabel)
                    self.offlineImage.hidden = false
                    self.statusLabel.hidden = false
                    self.activityIndicatorView.stopAnimating()
                    self.activityIndicatorView.removeFromSuperview()
                }
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            self.statusLabel.hidden = true
                            self.offlineImage.hidden = true
                            self.movies = responseDictionary["results"] as? [NSDictionary]
                            self.filtered = self.movies!
                            self.tableView.reloadData()
                            self.activityIndicatorView.stopAnimating()
                            self.activityIndicatorView.removeFromSuperview()
                    }
                }
        });
        task.resume()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
//        print("active")
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false
        
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
        searchBar.resignFirstResponder()
    }
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filtered = movies!.filter({ (movie) -> Bool in
            
            let tmp: String = movie["title"] as! String
            if (tmp.containsString(searchText)) {
                return true
            } else {
                return false
            }
//            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
//            return range?.count > 0
        })
        
//        if(filtered.count == 0){
//            searchActive = false
//        } else {
//            searchActive = true
//        }
        if searchText.characters.count > 0 {
            searchActive = true
        } else {
            searchActive = false
//            searchBar.resignFirstResponder()
        }
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        } else {
            if let movies = movies { // if movies not nill
                return movies.count
            } else {
                return 0
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let currentCell = tableView.cellForRowAtIndexPath(indexPath)! as UITableViewCell
        self.performSegueWithIdentifier("details", sender: currentCell)
        searchBar.resignFirstResponder()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if let cell = sender as? UITableViewCell {
            let row = tableView.indexPathForCell(cell)!.row
            if segue.identifier == "details" {
                searchActive = false
                let vc = segue.destinationViewController as! DetailedViewController
                let movie = movies![row]
                let title = movie["title"] as! String
                let description = movie["overview"] as! String
                let youtubekey = movie["id"] as! Int
                vc.titlePassed = title
                vc.descriptionPassed = description
                vc.YouTubeId = youtubekey
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        
        cell.accessoryType = UITableViewCellAccessoryType.None
        
        if searchActive && filtered.count > 0 {
            let movie = filtered[indexPath.row]
            let title = movie["title"] as! String
            let releaseDate = movie["release_date"] as! String
            let votes = movie["vote_average"] as! Float
            let roundedVotes = votes/2.0
            let overview = movie["overview"] as! String
            let baseUrl = "http://image.tmdb.org/t/p/w500"
            
            if let posterPath = movie["poster_path"] as? String {
                let imageUrl = NSURL(string: baseUrl + posterPath)
                let imageRequest = NSURLRequest(URL: imageUrl!)
                
                cell.posterView.setImageWithURLRequest(
                    imageRequest,
                    placeholderImage: nil,
                    success: { (imageRequest, imageResponse, image) -> Void in
                        
                        // imageResponse will be nil if the image is cached
                        if imageResponse != nil {
                            //                        print("Image was NOT cached, fade in image")
                            cell.posterView.alpha = 0.0
                            cell.posterView.image = image
                            UIView.animateWithDuration(0.3, animations: { () -> Void in
                                cell.posterView.alpha = 1.0
                            })
                        } else {
                            //                        print("Image was cached so just update the image")
                            cell.posterView.image = image
                        }
                    },
                    failure: { (imageRequest, imageResponse, error) -> Void in
                        // do something for the failure condition
                        cell.posterView.image = UIImage(named: "no_image.png")
                })
            } else {
                cell.posterView.image = UIImage(named: "no_image.png")
            }
            
            cell.floatRatingView.rating = Float(roundedVotes)
            cell.releasedOn.text = releaseDate
            cell.titleLabel.text = title
            cell.overviewLabel.text = overview
            cell.textLabel!.sizeToFit()
            return cell
        } else {
            
            let movie = movies![indexPath.row]
            let title = movie["title"] as! String
            let releaseDate = movie["release_date"] as! String
            let votes = movie["vote_average"] as! Float
            let roundedVotes = votes/2.0
            let overview = movie["overview"] as! String
            let baseUrl = "http://image.tmdb.org/t/p/w500"
            
            
            if let posterPath = movie["poster_path"] as? String {
                let imageUrl = NSURL(string: baseUrl + posterPath)
                let imageRequest = NSURLRequest(URL: imageUrl!)
                
                cell.posterView.setImageWithURLRequest(
                    imageRequest,
                    placeholderImage: nil,
                    success: { (imageRequest, imageResponse, image) -> Void in
                        
                        // imageResponse will be nil if the image is cached
                        if imageResponse != nil {
                            //                        print("Image was NOT cached, fade in image")
                            cell.posterView.alpha = 0.0
                            cell.posterView.image = image
                            UIView.animateWithDuration(0.3, animations: { () -> Void in
                                cell.posterView.alpha = 1.0
                            })
                        } else {
                            //                        print("Image was cached so just update the image")
                            cell.posterView.image = image
                        }
                    },
                    failure: { (imageRequest, imageResponse, error) -> Void in
                        // do something for the failure condition
                        cell.posterView.image = UIImage(named: "no_image.png")
                })
            } else {
                cell.posterView.image = UIImage(named: "no_image.png")
            }
            
            cell.floatRatingView.rating = Float(roundedVotes)
            cell.releasedOn.text = releaseDate
            cell.titleLabel.text = title
            cell.overviewLabel.text = overview
            cell.textLabel!.sizeToFit()
            return cell
        }
    }
    
    deinit {
        tableView.dg_removePullToRefresh()
    }
}
