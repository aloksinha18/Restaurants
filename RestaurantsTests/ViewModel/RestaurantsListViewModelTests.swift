//
//  RestaurantsListViewModel.swift
//  RestaurantsTests
//
//  Created by Alok Sinha on 2022-06-27.
//

import XCTest
@testable import Restaurants

class MockRestaurantsLoader: RestaurantLoader {
    private let result: Result<[Restaurant], Error>
    
    init(result: Result<[Restaurant], Error>) {
        self.result = result
    }
        
    func load(completion: (Result<[Restaurant], Error>) -> Void) {
        completion(result)
    }
}

final class RestaurantsListViewModelTests: XCTestCase {
    
    func test_load_in_sorted_order() {
        let firstRestaurant = getRestaurant(with: "First Restaurant", status: .closed)
        let secondRestaurant = getRestaurant(with: "Second Restaurant", status: .statusOpen)
        let thirdRestaurant = getRestaurant(with: "Third Restaurant", status: .orderAhead)
        let loader = MockRestaurantsLoader(result: .success([firstRestaurant, secondRestaurant, thirdRestaurant]))
        let sut = RestaurantsListViewModel(loader: loader)
        sut.load()
        sut.onLoad = { result in
            XCTAssertEqual(result[0].status, .statusOpen)
            XCTAssertEqual(result[1].status, .orderAhead)
            XCTAssertEqual(result[2].status, .closed)
        }
    }
    
    func test_load_fails() {
        let loader = MockRestaurantsLoader(result: .failure(anyNSError()))
        let sut = RestaurantsListViewModel(loader: loader)
        sut.load()
        sut.onFail = { error in
            XCTAssertNotNil(error)
        }
    }
    
    func test_load_in_sorted_order_after_search() {
        let firstClosedRestaurant = getRestaurant(with: "First Restaurant", status: .closed)
        let firstOpenRestaurant = getRestaurant(with: "First Restaurant", status: .orderAhead)
        let firstOrderaheadRestaurant = getRestaurant(with: "First Restaurant", status: .statusOpen)
        let secondRestaurant = getRestaurant(with: "Second Restaurant", status: .statusOpen)
        let thirdRestaurant = getRestaurant(with: "Third Restaurant", status: .orderAhead)
        
        let sut = RestaurantsListViewModel(loader: MockRestaurantsLoader(result: .success([firstClosedRestaurant,firstOpenRestaurant,firstOrderaheadRestaurant, secondRestaurant, thirdRestaurant])))

        sut.sortedRestaurantsByName("First")
        
        sut.onLoad = { result in
            XCTAssertEqual(result.count, 3)
            XCTAssertEqual(result[0].status, .statusOpen)
            XCTAssertEqual(result[1].status, .orderAhead)
            XCTAssertEqual(result[2].status, .closed)
        }
    }
    
    func test_resetting_restaurants_after_removing_search() {
        let firstClosedRestaurant = getRestaurant(with: "First Restaurant", status: .closed)
        let firstOpenRestaurant = getRestaurant(with: "First Restaurant", status: .orderAhead)
        let firstOrderaheadRestaurant = getRestaurant(with: "First Restaurant", status: .statusOpen)
        let secondRestaurant = getRestaurant(with: "Second Restaurant", status: .statusOpen)
        let thirdRestaurant = getRestaurant(with: "Third Restaurant", status: .orderAhead)
        
        let sut = RestaurantsListViewModel(loader: MockRestaurantsLoader(result: .success([firstClosedRestaurant,firstOpenRestaurant,firstOrderaheadRestaurant, secondRestaurant, thirdRestaurant])))

        sut.sortedRestaurantsByName("First")
        sut.removeSearch()
        sut.onLoad = { result in
            XCTAssertEqual(result.count, 5)
            XCTAssertEqual(result[0].status, .statusOpen)
            XCTAssertEqual(result[1].status, .statusOpen)
            XCTAssertEqual(result[2].status, .orderAhead)
            XCTAssertEqual(result[3].status, .orderAhead)
            XCTAssertEqual(result[4].status, .closed)
        }
    }
    
    private func getRestaurant(with name: String, status: Status)-> Restaurant {
        Restaurant(name: name, status: status, sortingValues: SortingValues(bestMatch: 0.0, newest: 96.0, ratingAverage: 4.5, distance: 1190, popularity: 17, averageProductPrice: 1536, deliveryCosts: 200, minCost: 1000))
    }
    
    private func anyNSError() -> NSError {
        NSError(domain: "Test", code: 404)
    }
}
