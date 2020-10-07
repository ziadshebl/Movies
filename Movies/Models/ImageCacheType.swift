//
//  ImageCacheType.swift
//  Movies
//
//  Created by kamal badawy on 9/27/20.
//

import Foundation
import UIKit

protocol ImageCacheType: class {
    //A function to convert the image url into a UIImage
    //Input: The url of the imadge need to be rendered
    //Output: The image as UIImage
    func image(for url: URL) -> UIImage?

    //A function to cache an image with a specific url
    //Input: The url of the image, and the image itself as UIImage
    func insertImage( _ image: UIImage?, for url: URL)
    
    //A function to remove the image of a specified url from the cache
    //Input: The url of the image
    func removeImage(for url: URL)
    
    //A function to remove all the images from the cache
    //Input: The url of the image
    func removeAllImages()
    
    //Reading the image of a specific url
    //Input: The url of the image
    subscript(_ url: URL) -> UIImage? {get set}
}
