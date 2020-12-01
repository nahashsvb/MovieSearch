//
//  APIService.swift
//  MovieSearch
//
//  Created by Serhii Borysov on 11/30/20.
//

import Foundation

struct Constants {
    static let APIKey = "8454c1c7"
}

protocol APIServiceDelegate: class {
    func didFinishWithError(_ error: APIError)
    func didFinishWithMovies(_ movies: [MovieFullData])
}

enum APIError: String, Error {
    case notFoundError = "Movie not found!"
    case noInternet = "No Internet"
    case noResults = "No Results Yet"
}

class APIService {
    fileprivate let searchUrlFormat = "http://www.omdbapi.com/?apikey=%@&s=%@&page=%d"
    fileprivate let detailsUrlFormat = "http://www.omdbapi.com/?apikey=%@&i=%@&plot=full"

// MARK: - Public Properties
    weak var delegate: APIServiceDelegate?
    
// MARK: - Private Properties
    private var subtasks = [URLSessionDataTask]()
    private var moviesShortData = [MovieShortData]()
    private var moviesFullData = [MovieFullData]()
    private var subtasksFinished = 0;

// MARK: - Public Functions
    func searchMovie(searchQuery query: String, currentPage page: Int) {
        self.cancelAllSubtasks()
        
        if !Reachability.isConnectedToNetwork() {
            self.delegate?.didFinishWithError(.noInternet)
            return
        }

        let fetchURL = String(format: searchUrlFormat, Constants.APIKey, query, page)
        guard let sourcesURL = URL(string: fetchURL) else {
            self.delegate?.didFinishWithError(.notFoundError)
            return
        }
        
        URLSession.shared.dataTask(with: sourcesURL) { [weak self] (data, urlResponse, error)  in
            if let data = data {
                let jsonDecoder = JSONDecoder()
                do {
                    let moviesData = try jsonDecoder.decode(MoviesData.self, from: data)
                    self?.moviesShortData = moviesData.movies
                    self?.moviesFullData = [MovieFullData]()
                    self?.getMoviesDetails()
                } catch let parseError {
                    print(parseError.localizedDescription)
                    do {
                        let errorData = try jsonDecoder.decode(ResponseError.self, from: data)
                        print(errorData.error)
                        self?.delegate?.didFinishWithError(.notFoundError)
                    } catch let parseResponseError {
                        print(parseResponseError.localizedDescription)
                        self?.delegate?.didFinishWithError(.notFoundError)
                    }
                }
            }
            
        }.resume()
    }
// MARK: - Private Functions
    private func getMoviesDetails() {
        self.cancelAllSubtasks()
        
        for movie: MovieShortData in self.moviesShortData {
            
            if !Reachability.isConnectedToNetwork() {
                self.cancelAllSubtasks()
                self.delegate?.didFinishWithError(.noInternet)
                return
            }

            let fetchURL = String(format: detailsUrlFormat, Constants.APIKey, movie.imdbID)
            guard let sourcesURL = URL(string: fetchURL) else {
                continue
            }
            
            let subtask = URLSession.shared.dataTask(with: sourcesURL) { [weak self] (data, urlResponse, error) in
                self?.subtasksFinished += 1
                
                if let data = data {
                    let jsonDecoder = JSONDecoder()
                    do {
                        let movieDetailsData = try jsonDecoder.decode(MovieFullData.self, from: data)
                        self?.moviesFullData.append(movieDetailsData)
                    } catch let error {
                        print(error.localizedDescription)
                        do {
                            let errorData = try jsonDecoder.decode(ResponseError.self, from: data)
                            print(errorData.error)
//                            self?.delegate?.didFinishWithError(.unexpectedError)
                        } catch let error {
                            print(error.localizedDescription)
//                            self?.delegate?.didFinishWithError(.unexpectedError)
                        }
                    }
                }
                
                self?.checkIfAllSubtasksFinished()
            }
            
            self.subtasks.append(subtask)
        }
        
        self.resumeAllSubtasks()
    }
    
    private func checkIfAllSubtasksFinished() {
        for subtask : URLSessionDataTask in self.subtasks {
            if subtask.state == .running {
                return
            }
        }
        
        if self.subtasksFinished == self.subtasks.count {
            if self.moviesFullData.count > 0 {
                self.delegate?.didFinishWithMovies(self.moviesFullData)
            }
            else {
                self.delegate?.didFinishWithError(.noResults)
            }
        }
    }
    
    private func resumeAllSubtasks() {
        for subtask : URLSessionDataTask in self.subtasks {
            subtask.resume()
        }
    }
    
    private func cancelAllSubtasks() {
        for task : URLSessionDataTask in self.subtasks {
            task.cancel()
        }
        self.subtasksFinished = 0;
        self.subtasks.removeAll()
    }
}
