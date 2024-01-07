//
//  MoviesViewModel.swift
//  MoviesApp
//
//  Created by Dina ElShabassy on 05/01/2024.
//

import Foundation

class MoviesViewModel {
    
    var networkService : NetworkService!
    
    var totalPages : Int!
    var moviesArray = [MovieObj](){
        
       didSet{
           self.bindMoviesViewModelToView()
       }
   }
    
   var showError : String! {
       
       didSet{
           self.bindShowErrorToView()
       }
   }
    
    //2 properties of this funtion type to bind the viewModel to the view
    var bindMoviesViewModelToView : (()->()) = {}
    var bindShowErrorToView : (()->()) = {}
    
    init() {
        networkService = NetworkService()
    }
    
    func getNowPlayingMovies(pageNumber : Int){
        networkService.getNowPlayingMovies(page: pageNumber) { [unowned self] movieResult, error in
            if let movieResult = movieResult {
                totalPages = movieResult.total_pages
                moviesArray.append(contentsOf: movieResult.results ?? [])
            }else{
                showError = error?.localizedDescription
            }
        }
    }
    
    func getMostPopularMovies(pageNumber : Int){
        networkService.getPopularMovies(page: pageNumber) { [unowned self] movieResult, error in
            if let movieResult = movieResult {
                totalPages = movieResult.total_pages
                moviesArray.append(contentsOf: movieResult.results ?? [])
            }else{
                showError = error?.localizedDescription
            }
        }
    }
    
    func getTopRatedMovies(pageNumber : Int){
        networkService.getTopRatedMovies(page: pageNumber) { [unowned self] movieResult, error in
            if let movieResult = movieResult {
                totalPages = movieResult.total_pages
                moviesArray.append(contentsOf: movieResult.results ?? [])
            }else{
                showError = error?.localizedDescription
            }
        }
    }
}
