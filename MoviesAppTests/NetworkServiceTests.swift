//
//  NetworkServiceTests.swift
//  MoviesAppTests
//
//  Created by Dina ElShabassy on 07/01/2024.
//

import XCTest
@testable import MoviesApp

class NetworkServiceTests: XCTestCase {

    //for using the NetworkService model without mocking
    var networkService : NetworkService!
    //for mocking
    var mockNetworkService : MockNetworkService!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        networkService = NetworkService()
        
        mockNetworkService = MockNetworkService(shouldReturnError: false)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    //without mocking
    func testFetchMoviesFromAPI() {
           
           //Expection to test against asyncronous API's
           let expectationObj = expectation(description: "wait for response")
        networkService.requestMovies(sortingCriteria: .nowPlaying,page: 1, completion: { movies, error in
            
            if let moviesArray = movies{
                expectationObj.fulfill()
                //this will succeed
                XCTAssertEqual(moviesArray.results?.count, 20)
                //this will fail
                //XCTAssertEqual(moviesArray.results?.count, 1)
                
            }else{
                XCTFail()
            }
            
        })
        waitForExpectations(timeout: 10)
           
    }
    
    //with mocking
    func testFetchMoviesFromAPIWithMocking() {
           
           //Expection to test against asyncronous API's
           let expectationObj = expectation(description: "wait for response")
        mockNetworkService.requestMovies(sortingCriteria: .nowPlaying,page: 1, completion: { movies, error in
            
            if let moviesArray = movies{
                expectationObj.fulfill()
                //this will fail cause our array's count only 2
                //XCTAssertEqual(moviesArray.count, 20)
                //this will succeed
                XCTAssertEqual(moviesArray.results?.count, 2)
                 
             }else{
                 //will fail if the boolean shouldReturnError is true
                 XCTFail()
             }
            
        })
        waitForExpectations(timeout: 10)
           
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
