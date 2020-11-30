//
//  SearchMoviesViewController.swift
//  MovieSearch
//
//  Created by Serhii Borysov on 11/29/20.
//

import UIKit

// TODO: Implement the search logic, add the search bar + collection view universal UI
class SearchMoviesViewController: UIViewController {

    private var moviesViewModel : MoviesViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callToViewModelForUIUpdates()
    }
    
    func callToViewModelForUIUpdates(){
        self.moviesViewModel = MoviesViewModel()
        self.moviesViewModel.bindMoviesToController = { [weak self] in
            self?.updateDataSource()
        }
        
        self.moviesViewModel.bindErrorToController = { [weak self] in
            self?.showError()
        }
    }
    
    func showError() {
        // TODO: Show error
    }
    
    func updateDataSource() {
        let movies = self.moviesViewModel.moviesData
        // TODO: Update the collection view
    }
}

