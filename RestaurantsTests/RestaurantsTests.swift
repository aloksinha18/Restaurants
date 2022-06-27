//
//  RestaurantsTests.swift
//  RestaurantsTests
//
//  Created by Alok Sinha on 2022-06-26.
//

import XCTest
@testable import Restaurants

protocol RestaurantStore {
    func get(completion: @escaping (Result<Data, Error>)-> Void)
}

class LocalRestaurantLoader {
    
    enum Error: Swift.Error {
        case invalidData
    }
    
    private let store: RestaurantStore
    
    init(store: RestaurantStore) {
        self.store = store
    }
    
    func load(completion: @escaping (RestaurantLoader.Result) -> Void) {
        store.get { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                do {
                    let items = try self.parseResponse(data: data)
                    completion(items)
                } catch {
                    completion(.failure(error))
                }
            case .failure:
                completion(.failure(Error.invalidData))
            }
        }
    }
    
    private func parseResponse(data: Data) throws -> RestaurantLoader.Result {
        let decoder = JSONDecoder()
        
        do {
            let iems =  try decoder.decode(Root.self, from: data)
            return .success(iems.restaurants)
        } catch {
            throw LocalRestaurantLoader.Error.invalidData
        }
    }
}


class RestaurantStoreSpy: RestaurantStore {
    
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

final class LocalRestaurantLoaderTests: XCTestCase {
    
    func test_load_fails_on_retrival() {
        
        let store = RestaurantStoreSpy()
        let sut = LocalRestaurantLoader(store: store)
        sut.load { result in
            switch result {
            case let (.failure(receivedError as NSError)):
                XCTAssertEqual(receivedError, LocalRestaurantLoader.Error.invalidData as NSError)
            default:
                XCTFail("Expecting failure")
            }
        }
        store.complete(with: anyNSError())
    }
    
    func test_load_sucess_on_retrival() {
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
    
    private func anyNSError() -> NSError {
        NSError(domain: "Test", code: 404)
    }
}
