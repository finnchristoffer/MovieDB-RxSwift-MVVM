//
//  Movie.swift
//  MovieDB-RxSwift-MVVM
//
//  Created by Finn Christoffer Kurniawan on 18/02/23.
//

import Foundation

struct MovieResponse: Codable {
    var results: [Movie]
}

struct Movie: Codable, Identifiable {
    let id: Int
    let title: String
    let releaseDate: String
    let backdrop: String?
    let poster: String?
    let language: String
    let overview: String
    let runtime: Int?
    let genres: [Genres]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case releaseDate = "release_date"
        case poster = "poster_path"
        case backdrop = "backdrop_path"
        case language = "original_language"
        case overview
        case runtime
        case genres
    }
}

struct Genres: Codable {
    let id: Int
    let name: String
}
