//
//  Constants.swift
//  MoviesApp
//
//  Created by Dina ElShabassy on 05/01/2024.
//

import Foundation
import UIKit

struct Constants {
    
    static let baseURL = URL(string: "https://api.themoviedb.org/3")
    static let accessToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJhY2Y5NDNjOTE2NTM4OGMxNGYyMjhhZDhhMTI1ODEwNSIsInN1YiI6IjY1OTVhZjZjMzI2ZWMxNTlmNzA2YzE4MiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.5i-NyUTAoyJcc2SfhOF5Tc9sa13Km61ZSLOjlXtCJsc"
    static let dropDownList = ["Sort by Most Popular" , "Sort by Top Rated", "Clear Sort"]
    static var imageBaseURL =  URL(string: "https://image.tmdb.org/t/p/w185/")
    
}
