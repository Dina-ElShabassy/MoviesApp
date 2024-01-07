//
//  MockNetworkService.swift
//  MoviesAppTests
//
//  Created by Dina ElShabassy on 07/01/2024.
//

import Foundation
@testable import MoviesApp

class MockNetworkService {
    
    //for testing scenarios
    var shouldReturnError : Bool
    
    init(shouldReturnError : Bool) {
        self.shouldReturnError = shouldReturnError
    }
    
    var error : Error!
    
    //JSON data with 2 movies for testing
    let mockMoviesJSONResponse : [String : Any] = [
        "results": [
          [
            "original_title": "The Family Plan",
            "overview": "Dan Morgan is many things: a devoted husband, a loving father, a celebrated car salesman. He's also a former assassin. And when his past catches up to his present, he's forced to take his unsuspecting family on a road trip unlike any other.",
            "poster_path": "/jLLtx3nTRSLGPAKl4RoIv1FbEBr.jpg",
            "release_date": "2023-12-14",
            "vote_average": 7.4
          ],
          [
            "original_title": "Rebel Moon - Part One: A Child of Fire",
            "overview": "When a peaceful colony on the edge of the galaxy finds itself threatened by the armies of the tyrannical Regent Balisarius, they dispatch Kora, a young woman with a mysterious past, to seek out warriors from neighboring planets to help them take a stand.",
            "poster_path": "/ui4DrH1cKk2vkHshcUcGt2lKxCm.jpg",
            "release_date": "2023-12-15",
            "vote_average": 6.474
          ]
        ],
        "total_pages": 171
    ]
    
}

extension MockNetworkService : ServiceProtocol{

    func requestMovies(sortingCriteria : SortingCriteria, page: Int, completion: @escaping (MovieResult?, Error?) -> ()){

        var movieResult : MovieResult!

        do{
            //converting json to data(NSData)
            let moviesData = try JSONSerialization.data(withJSONObject: mockMoviesJSONResponse, options: .fragmentsAllowed)

            //converting data to movieResult object (decoding)
            movieResult = try JSONDecoder().decode(MovieResult.self, from: moviesData)

        }catch let error {
            print(error.localizedDescription)
        }

        if shouldReturnError{
            completion(nil,error)
        }else{
            completion(movieResult,nil)
        }
    }
    
}
