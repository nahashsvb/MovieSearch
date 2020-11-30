//
//  MoviesViewModel.swift
//  MovieSearch
//
//  Created by Serhii Borysov on 11/30/20.
//

import Foundation

class MoviesViewModel : NSObject {
    private var apiService : APIService!
    private(set) var moviesData : [MovieFullData] {
        didSet {
            self.bindMoviesToController()
        }
    }
    
    private(set) var error : Error? {
        didSet {
            self.bindErrorToController()
        }
    }
    
    var bindMoviesToController : (() -> ()) = {}
    var bindErrorToController : (() -> ()) = {}
    
    override init() {
        self.moviesData = [MovieFullData]()
        super.init()
        self.apiService =  APIService()
        self.apiService.delegate = self
// Uncomment to test
        getMovies(searchQuery: "Love", currentPage: 1)
    }
    
    func getMovies(searchQuery query: String, currentPage page: Int) {
        self.apiService.searchMovie(searchQuery: query, currentPage: page)
    }
}

extension MoviesViewModel : APIServiceDelegate {
    func didFinishWithError(_ error: APIError) {
        self.error = error
    }
    
    func didFinishWithMovies(_ movies: [MovieFullData]) {
        self.moviesData = movies
    }
}
