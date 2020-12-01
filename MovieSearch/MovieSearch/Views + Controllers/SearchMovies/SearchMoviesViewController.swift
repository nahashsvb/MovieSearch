//
//  SearchMoviesViewController.swift
//  MovieSearch
//
//  Created by Serhii Borysov on 11/29/20.
//

import UIKit

class SearchMoviesViewController: UIViewController {

    private var moviesViewModel : MoviesViewModel!
    private let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var infoLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Movies List"
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.allowsSelection = true
        self.collectionView.allowsMultipleSelection = false
        
        let cellNib = UINib(nibName: MovieCollectionViewCell.nibName(), bundle: nil)
        self.collectionView.register(cellNib, forCellWithReuseIdentifier: MovieCollectionViewCell.reuseIdentifier())
        
        let loadingCellNib = UINib(nibName: MovieLoadingCollectionViewCell.nibName(), bundle: nil)
        self.collectionView.register(loadingCellNib, forCellWithReuseIdentifier: MovieLoadingCollectionViewCell.reuseIdentifier())
        
        self.setupSearchController()
        
        callToViewModelForUIUpdates()
    }
    
    func setupSearchController() {
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Enter movie search query "
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
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
        DispatchQueue.main.async {  [weak self] in
            self?.collectionView.alpha = CGFloat(0)
            self?.infoLabel.alpha = CGFloat(1)
            self?.infoLabel.text = self?.moviesViewModel.error?.rawValue
        }
    }
    
    func hideError() {
        self.collectionView.alpha = CGFloat(1)
        self.infoLabel.alpha = CGFloat(0)
    }
    
    func updateDataSource() {
        DispatchQueue.main.async {  [weak self] in
            self?.collectionView.reloadData()
            self?.hideError()
        }
    }
}

extension SearchMoviesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:CGFloat(360), height: CGFloat(150))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: CGFloat(10), left: CGFloat(10), bottom: CGFloat(10), right: CGFloat(10))
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == self.moviesViewModel.moviesData.count {
            self.moviesViewModel.nextPage()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

// TODO: Move the datasource to the viewmodel
extension SearchMoviesViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.moviesViewModel.getNumberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.moviesViewModel.getNumberOfCells()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row < self.moviesViewModel.moviesData.count {
            let cell: MovieCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.reuseIdentifier(), for: indexPath) as! MovieCollectionViewCell
            
            let data = self.moviesViewModel.moviesData[indexPath.row]
            if let url = URL(string: data.poster) {
                cell.setPosterImageUrl(url)
            }
            cell.setMovieName(data.title)
            cell.setYearPlusGenre(data.year, data.genre)
            cell.setDirector(data.director)
            cell.setIMDBRating(data.imdbRatingString())
            cell.setRotteTomatoesRating(data.rotteTomatoesRatingString())
            cell.setMetacriticRating(data.metacriticRatingString())
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieLoadingCollectionViewCell.reuseIdentifier(), for: indexPath)
            return cell
        }
    }
}

extension SearchMoviesViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {
            return
        }

        self.moviesViewModel.getMovies(searchQuery: text, currentPage: 1)
        self.hideError()
    }
}
