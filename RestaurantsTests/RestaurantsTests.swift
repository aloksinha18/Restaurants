//
//  RestaurantsTests.swift
//  RestaurantsTests
//
//  Created by Alok Sinha on 2022-06-26.
//

import XCTest
@testable import Restaurants

protocol RestaurantStore {
    func get(completion: @escaping (RestaurantLoader.Result)-> Void)
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
        store.get { result in
            switch result {
            case .success:
                break
            case .failure:
                completion(.failure(Error.invalidData))
            }
        }
    }
}

class RestaurantStoreSpy: RestaurantStore {
    
    private var completion: ((Result<[Restaurant], Error>) -> Void)?
    
    func get(completion: @escaping (Result<[Restaurant], Error>) -> Void) {
        self.completion = completion
    }
    
    func complete(with error: Error) {
        completion?(.failure(error))
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
    
    private func anyNSError() -> NSError {
        NSError(domain: "Test", code: 404)
    }
}
