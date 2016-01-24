//
//  MovieCell.swift
//  Theater
//
//  Created by Tarang khanna on 1/13/16.
//  Copyright © 2016 Tarang khanna. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell, FloatRatingViewDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var overviewLabel: UILabel!
    
    @IBOutlet weak var posterView: UIImageView!
    
    @IBOutlet weak var releasedOn: UILabel!
    
    @IBOutlet var floatRatingView: FloatRatingView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.floatRatingView.emptyImage = UIImage(named: "StarEmpty")
        self.floatRatingView.fullImage = UIImage(named: "StarFull")
        // Optional params
        self.floatRatingView.delegate = self
        self.floatRatingView.contentMode = UIViewContentMode.ScaleAspectFit
        self.floatRatingView.maxRating = 5
        self.floatRatingView.minRating = 1
        self.floatRatingView.rating = 2.5
        self.floatRatingView.editable = true
        self.floatRatingView.halfRatings = true
        self.floatRatingView.floatRatings = false
    }
    
    func floatRatingView(ratingView: FloatRatingView, isUpdating rating:Float) {
//        self.liveLabel.text = NSString(format: "%.2f", self.floatRatingView.rating) as String
    }
    
    func floatRatingView(ratingView: FloatRatingView, didUpdate rating: Float) {
//        self.updatedLabel.text = NSString(format: "%.2f", self.floatRatingView.rating) as String
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
