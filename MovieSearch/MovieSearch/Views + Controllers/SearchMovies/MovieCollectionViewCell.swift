//
//  MovieCollectionViewCell.swift
//  MovieSearch
//
//  Created by Serhii Borysov on 11/30/20.
//

import UIKit
import SDWebImage

protocol Reusable {
    static func reuseIdentifier() -> String
    static func nibName() -> String
}

extension Reusable {
    static func reuseIdentifier() -> String {
        return String(describing: self)
    }

    static func nibName() -> String {
        return String(describing: self)
    }
}

class MovieCollectionViewCell: UICollectionViewCell, Reusable {
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var movieNameLabel: UILabel!
    @IBOutlet private weak var yearPlusGenreLabel: UILabel!
    @IBOutlet private weak var directorLabel: UILabel!
    
    @IBOutlet private weak var imdbRatingLabel: UILabel!
    @IBOutlet private weak var rotteTomatoesRatingLabel: UILabel!
    @IBOutlet private weak var metacriticRatingLabel: UILabel!
    

    func setPosterImageUrl(_ imageURL: URL) {
        self.posterImageView.sd_setImage(with: imageURL, placeholderImage: nil)
    }
    
    func setMovieName(_ name: String) {
        self.movieNameLabel.text = name
        self.movieNameLabel.lineBreakMode = .byTruncatingTail
    }
    
    func setYearPlusGenre(_ year: String, _ genre: String) {
        self.yearPlusGenreLabel.text = year + " | " + genre;
    }
    
    func setDirector(_ director: String) {
        self.directorLabel.text = "Directed by: " + director
    }
    
    func setIMDBRating(_ rating: String) {
        self.imdbRatingLabel.text = rating
    }
    
    func setRotteTomatoesRating(_ rating: String) {
        self.rotteTomatoesRatingLabel.text = rating
    }
    
    func setMetacriticRating(_ rating: String) {
        self.metacriticRatingLabel.text = rating
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.layer.cornerRadius = 10.0
        contentView.layer.masksToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.posterImageView.image = nil
        self.movieNameLabel.text = ""
        self.yearPlusGenreLabel.text = ""
        self.directorLabel.text = ""
        self.imdbRatingLabel.text = "N/A"
        self.rotteTomatoesRatingLabel.text = "N/A"
        self.metacriticRatingLabel.text = "N/A"
    }
}

