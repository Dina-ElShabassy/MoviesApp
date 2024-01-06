//
//  MoviesCollectionViewController.swift
//  MoviesApp
//
//  Created by Dina ElShabassy on 04/01/2024.
//

import UIKit
import DropDown
import SDWebImage

private let reuseIdentifier = "movieCell"

class MoviesCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var sortBarButton: UIBarButtonItem!
    
    let rightBarDropDown = DropDown()
    var moviesViewModel : MoviesViewModel!
    var moviesArray = [MovieObj]()
    var totalPages : Int = 0
    var estimatedWidth = 185.0
    var cellMarginSize = 10.0
    let activityIndicator = UIActivityIndicatorView(style: .large)
    	
    @IBAction func showBarButttonDropDown(_ sender: Any) {
        
        rightBarDropDown.show()
        // Action triggered on selection
        rightBarDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                
            if index == 0 {
                moviesViewModel.getPopularMovies(pageNumber: 1)
            }else if index == 1{
                moviesViewModel.getTopRatedMovies(pageNumber: 1)
            }else{
                moviesViewModel.getNowPlayingMovies(pageNumber: 1)
            }
            
            DispatchQueue.main.async {
                self.scrollToTop()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    func viewSetup() {
        //changing the tint color of the navigationbar
        self.navigationController?.navigationBar.tintColor = .black
        //text color of the navigationbar
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "Purple")]
        navigationController?.navigationBar.titleTextAttributes = textAttributes as [NSAttributedString.Key : Any]
        
        //show the activity indicator
        collectionView.backgroundView = activityIndicator
        activityIndicator.color = UIColor(named: "Purple")
        activityIndicator.startAnimating()
        
        title = "Movies List"
    }
     
    func dropDownSetup() {
        
        rightBarDropDown.anchorView = sortBarButton
        rightBarDropDown.dataSource = Constants.dropDownList
        rightBarDropDown.backgroundColor = .black
        rightBarDropDown.selectionBackgroundColor = .gray
        rightBarDropDown.selectedTextColor = UIColor(named: "Purple") ?? .white
        rightBarDropDown.textColor = UIColor(named: "Purple") ?? .white
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
        
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        moviesArray = moviesViewModel.result.results ?? []
        totalPages = moviesViewModel.result.total_pages ?? 0
        self.collectionView.reloadData()
        
    }
    
    //update the view if Fetching the movies failed
    func onFailureUpdateView(){
        
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        Alert().showAlert(title: "Error", message: moviesViewModel.showError, vc: self)
        
    }
    
    //function to scroll top when user is at the bottom of collection view
    func scrollToTop() {
        
        let topItem = IndexPath(item: 0, section: 0)
        self.collectionView.scrollToItem(at: topItem, at: .top, animated: false)
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

}


// MARK: Extension

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
