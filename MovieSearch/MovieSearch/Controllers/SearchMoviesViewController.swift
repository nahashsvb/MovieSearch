//
//  SearchMoviesViewController.swift
//  MovieSearch
//
//  Created by Serhii Borysov on 11/29/20.
//

import UIKit

class SearchMoviesViewController: UIViewController {

    private var moviesViewModel : MoviesViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callToViewModelForUIUpdates()
    }
    
    func callToViewModelForUIUpdates(){
        self.moviesViewModel = MoviesViewModel()
        self.moviesViewModel.bindMoviesToController = {
            self.updateDataSource()
        }
        
        self.moviesViewModel.bindErrorToController = {
            self.showError()
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
