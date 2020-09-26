//
//  Movie.swift
//  Movies
//
//  Created by kamal badawy on 9/23/20.
//

import Foundation
import RealmSwift

struct MovieJSONObject: Codable, Hashable, Equatable {

    let title: String
    let year: Int
    let cast: [String]
    let genres: [String]
    let rating: Int

}


class Movie: Object {
    
    @objc dynamic var title = ""
    @objc dynamic var  year = 0
    var  cast = List<Cast>()
    var genres = List<Genre>()
    @objc dynamic var  rating = 0
    
}


class Cast: Object, Codable {
    @objc dynamic var castMember: String = ""
}

class Genre: Object, Codable {
    @objc dynamic var genre: String = ""
}
