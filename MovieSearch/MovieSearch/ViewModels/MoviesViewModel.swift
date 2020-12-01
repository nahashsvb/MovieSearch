//
//  MoviesViewModel.swift
//  MovieSearch
//
//  Created by Serhii Borysov on 11/30/20.
//

import Foundation

class MoviesViewModel : NSObject {
    private var apiService : APIService!
    private var currentPage: Int!
    private var searchTerm: String!
    
    private(set) var moviesData : [MovieFullData] {
        didSet {
            self.bindMoviesToController()
        }
    }
    
    private(set) var error : APIError? {
        didSet {
            self.bindErrorToController()
        }
    }
    
    var bindMoviesToController : (() -> ()) = {}
    var bindErrorToController : (() -> ()) = {}
    
    override init() {
        self.moviesData = [MovieFullData]()
        self.currentPage = 1
        self.searchTerm = ""
        
        super.init()
        self.apiService =  APIService()
        self.apiService.delegate = self
// Uncomment to test
//        getMovies(searchQuery: "Love", currentPage: 1)
    }
    
    func nextPage() {
        self.currentPage = self.currentPage + 1
        self.apiService.searchMovie(searchQuery: self.searchTerm, currentPage: self.currentPage)
    }
    
    func getMovies(searchQuery query: String, currentPage page: Int) {
        self.moviesData = [MovieFullData]()
        self.currentPage = 1
        self.searchTerm = query
        self.apiService.searchMovie(searchQuery: query, currentPage: page)
    }
    
    func getCellMovieData(atIndexPath indexPath: IndexPath) -> MovieFullData {
        return self.moviesData[indexPath.row]
    }

    func getNumberOfCells() -> Int {
        if moviesData.count == 0 {
            return 0
        }
        
        return (moviesData.count + 1)
    }

    func getNumberOfSections() -> Int {
        return 1
    }
}

extension MoviesViewModel : APIServiceDelegate {
    func didFinishWithError(_ error: APIError) {
        self.error = error
    }
    
    func didFinishWithMovies(_ movies: [MovieFullData]) {
        self.moviesData.append(contentsOf: movies)
    }
}
