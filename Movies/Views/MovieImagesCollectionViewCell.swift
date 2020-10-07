//
//  MovieImagesCollectionViewCell.swift
//  Movies
//
//  Created by kamal badawy on 9/25/20.
//

import UIKit
import Combine

class MovieImagesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    //A function loading the image view with the image by building the url from the data of the photo
    //Input: The data of the photo to be displayed in the cell as FlickrPhoto
    func configureWithImages(photo: FlickrPhoto) {
            let url = URL(
                string: "https://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret)_b.jpg")
            if let imageUrl = url {
                let imageLoader = ImageLoader()
                var subscriptions = Set<AnyCancellable>()
                imageLoader.loadImage(from: imageUrl).sink { (imageToDisplay) in
                    self.image.image = imageToDisplay
                }.store(in: &subscriptions)
            }
    }

}
