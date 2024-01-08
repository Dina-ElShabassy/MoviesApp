//
//  MovieDetailsViewController.swift
//  MoviesApp
//
//  Created by Dina ElShabassy on 06/01/2024.
//

import UIKit
import SDWebImage

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var movieImageView: UIImageView!
   
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieOverview: UILabel!
    
    @IBOutlet weak var releaseDate: UILabel!
    
    @IBOutlet weak var rating: UILabel!
    var movieObj : MovieObj!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor(named: "Purple")
        movieTitle.textColor = UIColor(named: "Purple")
        
        // Do any additional setup after loading the view.
        if let imagePath = movieObj.poster_path {
            let imageURL = Constants.imageBaseURL?.appendingPathComponent(imagePath)
            movieImageView.sd_setImage(with: imageURL)
        }
        
        movieTitle.text = movieObj.original_title ?? ""
        movieOverview.text = movieObj.overview ?? ""
        releaseDate.text = movieObj.release_date ?? ""
        //get the first digit only after the decimal point
        let movieRate = Double(round((movieObj.vote_average ?? 0) * 10) / 10)
        rating.text = "\(movieRate)"
        
    }

}
