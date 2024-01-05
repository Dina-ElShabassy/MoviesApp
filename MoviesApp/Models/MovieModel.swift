//
//  MovieModel.swift
//  MoviesApp
//
//  Created by Dina ElShabassy on 05/01/2024.
//

import Foundation

struct MovieResult : Codable{
    let results : [MovieObj]?
    let total_pages : Int?
}

struct MovieObj : Codable{
    let original_title, overview, poster_path, release_date : String?
    let vote_average : Double?
}
