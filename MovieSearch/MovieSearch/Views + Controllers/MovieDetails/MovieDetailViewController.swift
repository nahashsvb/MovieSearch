//
//  MovieDetailViewController.swift
//  MovieSearch
//
//  Created by Serhii Borysov on 11/30/20.
//

import UIKit

class MovieDetailViewController: UIViewController {
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var movieNameLabel: UILabel!
    @IBOutlet private weak var yearPlusGenreLabel: UILabel!
    @IBOutlet private weak var actorsLabel: UILabel!
    @IBOutlet private weak var plotLabel: UILabel!
    @IBOutlet private weak var awardsLabel: UILabel!
    
    @IBOutlet private weak var imdbRatingLabel: UILabel!
    @IBOutlet private weak var rotteTomatoesRatingLabel: UILabel!
    @IBOutlet private weak var metacriticRatingLabel: UILabel!
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    var movieData: MovieFullData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateWith(self.movieData)
    }
    
    func setMovieData(_ info: MovieFullData) {
        self.movieData = info
    }
    
    private func updateWith(_ info: MovieFullData) {
        let poster: String = info.poster
        let replaced = poster.replacingOccurrences(of: "SX300", with: "SX2000")
        if let url = URL(string: replaced) {
            self.activityIndicator.startAnimating()
            self.posterImageView.sd_setImage(with: url) { [weak self] (image, error, cacheTpe, url) in
                self?.activityIndicator.stopAnimating()
            }
        }
        
        self.movieNameLabel.text = info.title
        self.yearPlusGenreLabel.text = info.year + " | " + info.genre
        self.actorsLabel.text = "Actors: " + info.actors
        self.plotLabel.text = "Plot: " + info.plot
        self.awardsLabel.text = "Awards: " + info.awards
        self.imdbRatingLabel.text = info.imdbRatingString();
        self.rotteTomatoesRatingLabel.text = info.rotteTomatoesRatingString();
        self.metacriticRatingLabel.text = info.metacriticRatingString();
    }
    
}
