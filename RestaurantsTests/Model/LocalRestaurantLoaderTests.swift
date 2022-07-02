//
//  RestaurantsTests.swift
//  RestaurantsTests
//
//  Created by Alok Sinha on 2022-06-26.
//

import XCTest
@testable import Restaurants

final class LocalRestaurantLoaderTests: XCTestCase {
    
    func test_load_fails_on_error() {
        
        let store = RestaurantStoreSpy()
        let sut = LocalRestaurantLoader(store: store)
        sut.load { result in
            switch result {
            case let (.failure(receivedError as NSError)):
                XCTAssertEqual(receivedError, LocalRestaurantLoader.Error.fileNotFound as NSError)
            default:
                XCTFail("Expecting failure")
            }
        }
        store.complete(with: anyNSError())
    }
    
    func test_load_fails_on_invalidData() {
        let store = RestaurantStoreSpy()
        let sut = LocalRestaurantLoader(store: store)
        
        let invalidDataString = """
                           {
                           "restaurants":{"name":"Raddisson", "status": "closed", "sortingValues": {"bestMatch":0.0,"newest":96.0,"ratingAverage":4.5,"distance":1190,"popularity":17.0,"averageProductPrice":1536,"deliveryCosts":200,"minCost":1000}}]
                           }
                         """
        
        let expectation = expectation(description: "wait for restaurant to load")
        sut.load { result in
            switch result {
            case let (.failure(receivedError as NSError)):
                XCTAssertEqual(receivedError, LocalRestaurantLoader.Error.invalidData as NSError)
            default:
                XCTFail("Expecting failure")
            }
            expectation.fulfill()
        }
        
        store.complete(with: invalidDataString.data(using: .utf8)!)
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_load_success_on_retrieval() {
        let store = RestaurantStoreSpy()
        let sut = LocalRestaurantLoader(store: store)
        
        let dataString = """
                           {
                           "restaurants":[{"name":"Raddisson", "status": "closed", "sortingValues": {"bestMatch":0.0,"newest":96.0,"ratingAverage":4.5,"distance":1190,"popularity":17.0,"averageProductPrice":1536,"deliveryCosts":200,"minCost":1000}}]
                           }
                         """
        
        let expectedResult = [Restaurant(name: "Raddisson", status: .closed, sortingValues: SortingValues(bestMatch: 0.0, newest: 96.0, ratingAverage: 4.5, distance: 1190, popularity: 17, averageProductPrice: 1536, deliveryCosts: 200, minCost: 1000))]
        
        
        let expectation = expectation(description: "wait for restaurant to load")
        sut.load { result in
            switch result {
            case let (.success(restaurant)):
                XCTAssertEqual(restaurant, expectedResult)
            default:
                XCTFail("Expecting Success")
            }
            expectation.fulfill()
        }
        
        store.complete(with: dataString.data(using: .utf8)!)
        wait(for: [expectation], timeout: 1.0)
    }
}

final private class RestaurantStoreSpy: RestaurantStore {
    
    private var completion: ((Result<Data, Error>) -> Void)?
    
    func get(completion: @escaping (Result<Data, Error>)-> Void) {
        self.completion = completion
    }
    
    func complete(with error: Error) {
        completion?(.failure(error))
    }
    
    func complete(with data: Data) {
        completion?(.success(data))
    }
}
