//
//  Movie.swift
//  Movies
//
//  Created by kamal badawy on 9/23/20.
//

import Foundation

struct Movie: Codable {
    
    let title: String
    let year: Int
    let cast: [String]
    let genres: [String]
    let rating: Int
    
}
