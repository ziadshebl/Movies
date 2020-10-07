//
//  ImageCache.swift
//  Movies
//
//  Created by kamal badawy on 9/27/20.
//

import Foundation
import UIKit

final class ImageCache {
    private let lock = NSLock()
    private let config: Config
    struct Config {
        let countLimit: Int
        let memoryLimit: Int
        
        static let defaultConfig = Config(countLimit: 100, memoryLimit: 1024*1024*100)
    }
    
    init(config: Config = Config.defaultConfig) {
        self.config = config
    }
    
    private lazy var imageCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.countLimit = config.countLimit
        return cache
    }()
    
    private lazy var decodedImageCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.totalCostLimit = config.memoryLimit
        return cache
    }()
}

extension ImageCache: ImageCacheType {
    
    //A function to convert the image url into a UIImage
    //Input: The url of the image need to be rendered
    //Output: The image as UIImage
    func image(for url: URL) -> UIImage? {
        lock.lock(); defer {lock.unlock()}
       
        if let decodedImage = decodedImageCache.object(forKey: url as AnyObject) as? UIImage {
            return decodedImage
        }
        
        if let image = imageCache.object(forKey: url as AnyObject) as? UIImage {
            let decodedImage = image.decodedImage()
            decodedImageCache.setObject(image as AnyObject, forKey: url as AnyObject)
            return decodedImage
        }
        
        return nil
    }
    
    //A function to cache an image with a specific url
    //Input: The url of the image, and the image itself as UIImage
    func insertImage(_ image: UIImage?, for url: URL) {
        
        guard let image = image else {return removeImage(for: url)}
        let decodedImage = image.decodedImage()
      
        lock.lock(); defer {lock.unlock()}
        imageCache.setObject(decodedImage, forKey: url as AnyObject)
        decodedImageCache.setObject(image as AnyObject, forKey: url as AnyObject)
        
    }
    
    //A function to remove the image of a specified url from the cache
    //Input: The url of the image
    func removeImage(for url: URL) {
        lock.lock(); defer {lock.unlock()}
        imageCache.removeObject(forKey: url as AnyObject)
        decodedImageCache.removeObject(forKey: url as AnyObject)
    }
    
    //A function to remove all the images from the cache
    //Input: The url of the image
    func removeAllImages() {
        imageCache.removeAllObjects()
        decodedImageCache.removeAllObjects()
    }
    
    //Reading the image of a specific url
    //Input: The url of the image
    subscript(_ key: URL) -> UIImage? {
        get {
            return image(for: key)
        }
        set {
            return insertImage(newValue, for: key)
        }
    }
    
}

extension UIImage {
    //A function responsible for decoding the image to decrease the time taken to render it
    func decodedImage() -> UIImage {
        guard let cgImage = cgImage else {return self}
        let size = CGSize(width: cgImage.width, height: cgImage.height)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: nil, width: Int(size.width),
                    height: Int(size.height), bitsPerComponent: 8, bytesPerRow: cgImage.bytesPerRow,
                    space: colorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        context?.draw(cgImage, in: CGRect(origin: .zero, size: size))
        
        guard let decodedImage = context?.makeImage() else {return self}
        
        return UIImage(cgImage: decodedImage)
    }
    
}
