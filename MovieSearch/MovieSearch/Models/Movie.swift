//
//  Movie.swift
//  MovieSearch
//
//  Created by Serhii Borysov on 11/30/20.
//

import Foundation

// MARK: - Error Response
struct MoviesData: Decodable {
    let movies: [MovieShortData]
    let response : String
    let totalResults : String
    
    enum CodingKeys: String, CodingKey {
        case movies         = "Search"
        case response       = "Response"
        case totalResults
    }
}

// MARK: - Error Response
struct ResponseError: Decodable {
    let response    : String
    let error       : String
    
    enum CodingKeys: String, CodingKey {
        case response   = "Response"
        case error      = "Error"
    }
}

// MARK: - Rating Structure - Part Of The Movie Details
struct Rating: Decodable {
    let source  : String
    let value   : String
    
    enum CodingKeys: String, CodingKey {
        case source = "Source"
        case value  = "Value"
    }
}

// MARK: - Search API Response Item
struct MovieShortData: Decodable {
    let title       : String
    let year        : String
    let imdbID      : String
    let type        : String
    let poster      : String
    
    enum CodingKeys: String, CodingKey {
        case title      = "Title"
        case year       = "Year"
        case imdbID
        case type       = "Type"
        case poster     = "Poster"
    }
}

// MARK: - Details API Response
struct MovieFullData: Decodable {
    let title       : String
    let year        : String
    let rated       : String
    let released    : String
    let runtime     : String
    let genre       : String
    let director    : String
    let writer      : String
    let actors      : String
    let plot        : String
    let language    : String
    let country     : String
    let awards      : String
    let poster      : String
    let ratings     : [Rating]
    let metascore   : String
    let imdbRating  : String
    let imdbVotes   : String
    let imdbID      : String
    let type        : String
    let dvd         : String
    let boxOffice   : String
    let production  : String
    let website     : String
    let response    : String

    func imdbRatingString() -> String {
        for rating in ratings {
            if rating.source == "Internet Movie Database" {
                return rating.value
            }
        }
        
        return "N/A"
    }
    
    func metacriticRatingString() -> String {
        for rating in ratings {
            if rating.source == "Metacritic" {
                return rating.value
            }
        }
        
        return "N/A"
    }
    
    func rotteTomatoesRatingString() -> String {
        for rating in ratings {
            if rating.source == "Rotten Tomatoes" {
                return rating.value
            }
        }
        
        return "N/A"
    }
    
    enum CodingKeys: String, CodingKey {
        case title      = "Title"
        case year       = "Year"
        case rated      = "Rated"
        case released   = "Released"
        case runtime    = "Runtime"
        case genre      = "Genre"
        case director   = "Director"
        case writer     = "Writer"
        case actors     = "Actors"
        case plot       = "Plot"
        case language   = "Language"
        case country    = "Country"
        case awards     = "Awards"
        case poster     = "Poster"
        case ratings    = "Ratings"
        case metascore  = "Metascore"
        case imdbRating
        case imdbVotes
        case imdbID
        case type       = "Type"
        case dvd        = "DVD"
        case boxOffice  = "BoxOffice"
        case production = "Production"
        case website    = "Website"
        case response   = "Response"
    }
}
