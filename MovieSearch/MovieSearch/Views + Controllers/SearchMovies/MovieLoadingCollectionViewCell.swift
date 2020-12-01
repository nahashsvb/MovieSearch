//
//  MovieLoadingCollectionViewCell.swift
//  MovieSearch
//
//  Created by Serhii Borysov on 12/1/20.
//

import UIKit

class MovieLoadingCollectionViewCell: UICollectionViewCell, Reusable {
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !self.activityIndicator.isAnimating {
            self.activityIndicator.startAnimating()
        }
        
        contentView.layer.cornerRadius = 10.0
        contentView.layer.masksToBounds = true
    }
}
