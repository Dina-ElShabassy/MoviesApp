//
//  MoviesCollectionViewController.swift
//  MoviesApp
//
//  Created by Dina ElShabassy on 04/01/2024.
//

import UIKit
import DropDown
import SDWebImage
import Lottie

private let reuseIdentifier = "movieCell"

class MoviesCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var sortBarButton: UIBarButtonItem!
    
    let rightBarDropDown = DropDown()
    var moviesViewModel : MoviesViewModel!
    var moviesArray = [MovieObj]()
    var totalPages : Int = 0
    var estimatedWidth = 185.0
    var cellMarginSize = 10.0
    var currentPage = 1
    let activityIndicator = UIActivityIndicatorView(style: .large)
    var currentSortingCriteria : SortingCriteria = .nowPlaying
    var isLoadingData : Bool!
    var animationView : AnimationView!
    	
    @IBAction func showBarButttonDropDown(_ sender: Any) {
        
        rightBarDropDown.show()
        // Action triggered on selection
        rightBarDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            currentPage = 1
            moviesArray.removeAll()
            moviesViewModel.moviesArray.removeAll()
            isLoadingData = true
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
            }
            
            if index == 0 {
                title = "Most Popular Movies"
                currentSortingCriteria = .mostPopular
                moviesViewModel.getMostPopularMovies(pageNumber: currentPage)
            }else if index == 1{
                title = "Top Rated Movies"
                currentSortingCriteria = .topRated
                moviesViewModel.getTopRatedMovies(pageNumber: currentPage)
            }else{
                title = "Now Playing Movies"
                currentSortingCriteria = .nowPlaying
                moviesViewModel.getNowPlayingMovies(pageNumber: currentPage)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.animationSetup()

        self.viewSetup()
        
        self.dropDownSetup()

        self.setupGridView()
        
        //create an instance from the movies view model class
        moviesViewModel = MoviesViewModel()
        //bind the result from the view model to view when fetching succeeded
        moviesViewModel.bindMoviesViewModelToView = {
            self.onSuccessUpdateView()
        }
        //bind the result from the view model to view when fetching failed
        moviesViewModel.bindShowErrorToView = {
            self.onFailureUpdateView()
        }
    }
    
    //reset the grid view if the device is rotated
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        
        self.setupGridView()

        DispatchQueue.main.async {
           self.collectionView.reloadData()
        }
    }
    
    // MARK: - ViewControllerFunctions
    
    func animationSetup() {
        
        animationView = .init(name: "Animation")
        
        self.collectionView.backgroundView = animationView
        self.navigationController?.navigationBar.isHidden = true

        animationView.animationSpeed = 0.5
        //play the animation view for 5 secs and after that fetch now playing movies to display them
        animationView.play { _ in
            UIView.animate(withDuration: 0.5, animations: {
                self.animationView.alpha = 0
            }, completion: {[self] _ in
                self.navigationController?.navigationBar.isHidden = false
                //show the activity indicator
                collectionView.backgroundView = activityIndicator
                activityIndicator.color = UIColor(named: "Purple")
                activityIndicator.startAnimating()
                moviesViewModel.getNowPlayingMovies(pageNumber: currentPage)
                
            })
        }
    }
    
    func viewSetup() {
        //changing the tint color of the navigationbar
        self.navigationController?.navigationBar.tintColor = .black
        //text color of the navigationbar
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "Purple")]
        navigationController?.navigationBar.titleTextAttributes = textAttributes as [NSAttributedString.Key : Any]
        
        title = "Now Playing Movies"
        
        isLoadingData = true
        collectionView.isPrefetchingEnabled = true
    }
     
    func dropDownSetup() {
        
        rightBarDropDown.anchorView = sortBarButton
        rightBarDropDown.dataSource = SortingCriteria.allValues.map{$0.rawValue}
        rightBarDropDown.backgroundColor = .black
        rightBarDropDown.selectionBackgroundColor = .gray
        rightBarDropDown.selectedTextColor = .white
        rightBarDropDown.textColor = .white
        rightBarDropDown.width = UIScreen.main.bounds.width/2
        rightBarDropDown.bottomOffset = CGPoint(x: 0, y:(rightBarDropDown.anchorView?.plainView.bounds.height)!)
        
    }
    
    func setupGridView() {
        let flow = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        flow.minimumInteritemSpacing = CGFloat(self.cellMarginSize)
        flow.minimumLineSpacing = CGFloat(self.cellMarginSize)
    }
    
    //update the view if Fetching the movies succeeded
    func onSuccessUpdateView(){
        
        isLoadingData = false
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        moviesArray = moviesViewModel.moviesArray
        totalPages = moviesViewModel.totalPages
        self.collectionView.reloadData()
        
    }
    
    //update the view if Fetching the movies failed
    func onFailureUpdateView(){
        
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        Alert().showAlert(title: "Error", message: moviesViewModel.showError, vc: self)
        
    }
    
    func loadMoreData() {
        
        currentPage += 1
        isLoadingData = true
        
        if currentPage <= totalPages{
                switch currentSortingCriteria {
                case .mostPopular:
                    moviesViewModel.getMostPopularMovies(pageNumber: currentPage)
                case .topRated:
                    moviesViewModel.getTopRatedMovies(pageNumber: currentPage)
                case .nowPlaying:
                    moviesViewModel.getNowPlayingMovies(pageNumber: currentPage)
                }
        }
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "showDetailsSegue" {

            let detailsVC = segue.destination as! MovieDetailsViewController
            let cell = sender as! MovieCollectionViewCell
            let indexPaths = self.collectionView.indexPath(for: cell)
            detailsVC.movieObj = self.moviesArray[indexPaths!.row]

        }
        
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return moviesArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MovieCollectionViewCell
    
        
        // Configure the cell
        if let imagePath = moviesArray[indexPath.row].poster_path {
            let imageURL = Constants.imageBaseURL?.appendingPathComponent(imagePath)
            cell.movieImageView.sd_setImage(with: imageURL)
        }
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.section == collectionView.numberOfSections - 1 &&
                    indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1 {
                    if !isLoadingData{
                        loadMoreData()
                    }
                }
    }

}


// MARK: UICollectionViewDelegateFlowLayout Extension

extension MoviesCollectionViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.calculateWidth()
        
        return CGSize(width: width, height: 278)
        
    }
    
    func calculateWidth() -> CGFloat {
        let estimatedWidth = CGFloat(estimatedWidth)
        let cellCount = floor(CGFloat(self.view.frame.width) / estimatedWidth)
        
        let margin = CGFloat(cellMarginSize * 2)
        let width = (self.view.frame.size.width - CGFloat(cellMarginSize) * (cellCount - 1) - margin ) / cellCount
        
        return width
    }
    
}

// MARK: UICollectionViewDataSourcePrefetching Extension

extension MoviesCollectionViewController : UICollectionViewDataSourcePrefetching{

    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let dataIndex = indexPath.item

            // Check if data for the current index is not already loaded
            if dataIndex >= moviesArray.count {
                // Load additional data for the prefetched indexPath
                // This is where you can initiate the fetch for more data to be displayed soon
                if !isLoadingData {
                    loadMoreData()
                }
            }
        }

    }

}
