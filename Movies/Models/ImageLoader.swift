//
//  ImageLoader.swift
//  Movies
//
//  Created by kamal badawy on 9/27/20.
//

import Foundation
import UIKit
import Combine


final class ImageLoader{
    private let cache = ImageCache()
    
    //A function responsible for choosing either to load the image with a specific url from the internet or from the cached data
    //Input: The url of the image as URL
    func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never> {
        
        if let image = cache.image(for: url){
            return Just(image).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map{(data, _) -> UIImage? in self.cache.insertImage(UIImage(data: data), for: url); return UIImage(data: data)}
            .catch {error in return Just(nil)}
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
