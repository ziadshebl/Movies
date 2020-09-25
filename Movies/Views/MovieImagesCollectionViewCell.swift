//
//  MovieImagesCollectionViewCell.swift
//  Movies
//
//  Created by kamal badawy on 9/25/20.
//

import UIKit

class MovieImagesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
 
    
    //A function loading the image view with the image by building the url from the data of the photo
    //Input: The data of the photo to be displayed in the cell as FlickrPhoto
    func configureWithImages(photo: FlickrPhoto){
        do{
            let url = URL(string: "https://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret)_b.jpg")
            print(url!)
            if let imageUrl = url {
                let data = try Data(contentsOf: imageUrl)
                image.image = UIImage(data: data)
            }
            
        } catch {
            print(error)
        }
    }

}
