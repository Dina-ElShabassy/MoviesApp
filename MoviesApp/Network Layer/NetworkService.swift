//
//  NetworkService.swift
//  MoviesApp
//
//  Created by Dina ElShabassy on 04/01/2024.
//

import Foundation
import Alamofire

class NetworkService : ServiceProtocol{
    
    private let baseURL = Constants.baseURL
    private let accessToken = Constants.accessToken
    
    private func makeRequest(endPoint : String, params : [String : String] = [:] ,  completion: @escaping (MovieResult?,Error?) -> ()){
        
        let url = baseURL!.appendingPathComponent(endPoint)
        let headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken)", "language": "en-US"]
                
        AF.request(url, method: .get, parameters: params, headers: headers)
                    .validate()
                    .responseDecodable(of: MovieResult.self){ response in
                        switch response.result {
                            case .success(_):
                                guard let result = response.value else {
                                    return
                                }
                                completion(result,nil)
                            case .failure(let error):
                                completion(nil,error)
                        }
                    }
    }

    func requestMovies(sortingCriteria : SortingCriteria, page: Int, completion: @escaping (MovieResult?, Error?) -> ()) {
        let params = ["page": "\(page)"]
        var criteriaEndpoint : String!
        switch sortingCriteria {
        case .mostPopular:
            criteriaEndpoint = Constants.endpoints.mostPopular
        case .topRated:
            criteriaEndpoint = Constants.endpoints.topRated
        case .nowPlaying:
            criteriaEndpoint = Constants.endpoints.nowPlaying
        }
        makeRequest(endPoint: criteriaEndpoint, params: params, completion: completion)
    }
    
}
