//
//  ServiceProtocol.swift
//  MoviesApp
//
//  Created by Dina ElShabassy on 07/01/2024.
//

import Foundation

protocol ServiceProtocol {
    
    func requestMovies(sortingCriteria : SortingCriteria, page: Int, completion: @escaping (MovieResult?, Error?) -> ())
    
}
