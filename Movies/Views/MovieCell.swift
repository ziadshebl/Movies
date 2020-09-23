//
//  MovieCell.swift
//  Movies
//
//  Created by kamal badawy on 9/22/20.
//

import UIKit
class MovieCell: UITableViewCell {
    
    
    @IBOutlet weak var movieView: UIView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    @IBOutlet weak var movieReleaseYear: UILabel!
    @IBOutlet weak var movieRatingStarImage1: UIImageView!
    @IBOutlet weak var movieRatingStarImage2: UIImageView!
    @IBOutlet weak var movieRatingStarImage3: UIImageView!
    @IBOutlet weak var movieRatingStarImage4: UIImageView!
    @IBOutlet weak var movieRatingStarImage5: UIImageView!
    
    
    //A function responsible for filling the stars according to the rating
    //Input: Movie rating as Integer
    func adjustRatingStars(rating: Int) {
        if rating > 0 {
            movieRatingStarImage1.image = UIImage(systemName: "star.fill")
        }
        if rating > 1 {
            movieRatingStarImage2.image = UIImage(systemName: "star.fill")
        }
        if rating > 2 {
            movieRatingStarImage3.image = UIImage(systemName: "star.fill")
        }
        if rating > 3 {
            movieRatingStarImage4.image = UIImage(systemName: "star.fill")
        }
        if rating > 4 {
            movieRatingStarImage5.image = UIImage(systemName: "star.fill")
        }
        
    }

    
}
