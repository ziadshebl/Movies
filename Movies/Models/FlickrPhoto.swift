//
//  FlickrPhoto.swift
//  Movies
//
//  Created by kamal badawy on 9/24/20.
//

import Foundation

struct FlickrPhoto {
    
    var id: String
    var owner: String
    var secret: String
    var server: String
    var farm: String
    
    init(id: String, owner: String, secret: String, server: String, farm: Int){
        self.id = id
        self.owner = owner
        self.secret = secret
        self.server = server
        self.farm = String(farm)
    }
}
