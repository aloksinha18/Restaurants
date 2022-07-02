//
//  RestaurantsListViewModel.swift
//  RestaurantsTests
//
//  Created by Alok Sinha on 2022-06-27.
//

import XCTest
@testable import Restaurants

final class RestaurantsListViewModelTests: XCTestCase {
    
    func test_load_in_sorted_status_order() {
        let firstRestaurant = getRestaurant(status: .closed)
        let secondRestaurant = getRestaurant(status: .statusOpen)
        let thirdRestaurant = getRestaurant(status: .orderAhead)
        assert(restaurants: [firstRestaurant, secondRestaurant, thirdRestaurant], expectedOutput: [secondRestaurant, thirdRestaurant, firstRestaurant])
    }
    
    func test_load_fails_on_error() {
        let loader = MockRestaurantsLoader()
        let sut = RestaurantsListViewModel(restaurantLoader: loader, sortTypeManager: getSortTypeManager())
        sut.load()
        let expectation = expectation(description: "wait for restaurant to load")
        sut.onFail = { error in
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        loader.complete(with: anyNSError())
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_load_in_sortedOrder_after_search() {
        let firstRestaurant = getRestaurant(name: "First Restaurant-1", status: .closed)
        let secondRestaurant = getRestaurant(name: "First Restaurant-2", status: .orderAhead)
        let thirdRestaurant = getRestaurant(name: "First Restaurant-3", status: .statusOpen)
        let fourthRestaurant = getRestaurant(name: "Fourth Restaurant", status: .statusOpen)
        let fifthRestaurant = getRestaurant(name: "Fifth Restaurant", status: .orderAhead)
        let restaurants = [firstRestaurant,secondRestaurant,thirdRestaurant, fourthRestaurant, fifthRestaurant]
                
        assert(searchText: "First", restaurants: restaurants, expectedOutput: [thirdRestaurant, secondRestaurant, firstRestaurant])
    }    

    func test_load_in_sortedOrder_afterApplying_sortingOption_bestMatch() {
        let firstRestaurant = getRestaurant( status: .closed, bestMatch: 23)
        let secondRestaurant = getRestaurant(status: .orderAhead, bestMatch: 46)
        let thirdRestaurant = getRestaurant(status: .statusOpen, bestMatch: 56)
        let fourthRestaurant = getRestaurant(status: .statusOpen, bestMatch: 65)
        let fifthRestaurant = getRestaurant(status: .orderAhead, bestMatch: 76)
        let sixthRestaurant = getRestaurant(status: .statusOpen, bestMatch: 96)

        let restaurants = [firstRestaurant, secondRestaurant, thirdRestaurant, fourthRestaurant, fifthRestaurant, sixthRestaurant]
        let expectedOutput = [sixthRestaurant, fourthRestaurant, thirdRestaurant, fifthRestaurant, secondRestaurant, firstRestaurant]
        assert(searchText: nil, sortType: .bestMatch, restaurants: restaurants, expectedOutput: expectedOutput)
    }

    func test_load_in_sortedOrder_afterApplying_sortingOption_newest() {
        let firstRestaurant = getRestaurant( status: .closed, newest: 23)
        let secondRestaurant = getRestaurant(status: .orderAhead, newest: 46)
        let thirdRestaurant = getRestaurant(status: .statusOpen, newest: 56)
        let fourthRestaurant = getRestaurant(status: .statusOpen, newest: 65)
        let fifthRestaurant = getRestaurant(status: .orderAhead, newest: 76)
        let sixthRestaurant = getRestaurant(status: .statusOpen, newest: 96)

        let restaurants = [firstRestaurant, secondRestaurant, thirdRestaurant, fourthRestaurant, fifthRestaurant, sixthRestaurant]
        let expectedOutput = [sixthRestaurant, fourthRestaurant, thirdRestaurant, fifthRestaurant, secondRestaurant, firstRestaurant]
        assert(searchText: nil, sortType: .newest, restaurants: restaurants, expectedOutput: expectedOutput)
    }
    
    func test_load_in_sortedOrder_afterApplying_sortingOption_ratingAverage() {
        let firstRestaurant = getRestaurant( status: .closed, ratingAverage: 23)
        let secondRestaurant = getRestaurant(status: .orderAhead, ratingAverage: 46)
        let thirdRestaurant = getRestaurant(status: .statusOpen, ratingAverage: 56)
        let fourthRestaurant = getRestaurant(status: .statusOpen, ratingAverage: 65)
        let fifthRestaurant = getRestaurant(status: .orderAhead, ratingAverage: 76)
        let sixthRestaurant = getRestaurant(status: .statusOpen, ratingAverage: 96)

        let restaurants = [firstRestaurant, secondRestaurant, thirdRestaurant, fourthRestaurant, fifthRestaurant, sixthRestaurant]
        let expectedOutput = [sixthRestaurant, fourthRestaurant, thirdRestaurant, fifthRestaurant, secondRestaurant, firstRestaurant]
        assert(searchText: nil, sortType: .ratingAverage, restaurants: restaurants, expectedOutput: expectedOutput)
    }
    
    func test_load_in_sortedOrder_afterApplying_sortingOption_distance() {
        let firstRestaurant = getRestaurant( status: .closed, distance: 23)
        let secondRestaurant = getRestaurant(status: .orderAhead, distance: 46)
        let thirdRestaurant = getRestaurant(status: .statusOpen, distance: 56)
        let fourthRestaurant = getRestaurant(status: .statusOpen, distance: 65)
        let fifthRestaurant = getRestaurant(status: .orderAhead, distance: 76)
        let sixthRestaurant = getRestaurant(status: .statusOpen, distance: 96)

        let restaurants = [firstRestaurant, secondRestaurant, thirdRestaurant, fourthRestaurant, fifthRestaurant, sixthRestaurant]
        let expectedOutput = [thirdRestaurant, fourthRestaurant, sixthRestaurant, secondRestaurant, fifthRestaurant, firstRestaurant]
        assert(searchText: nil, sortType: .distance, restaurants: restaurants, expectedOutput: expectedOutput)
    }
    
    func test_load_in_sortedOrder_afterApplying_sortingOption_popularity() {
        let firstRestaurant = getRestaurant( status: .closed, popularity: 23)
        let secondRestaurant = getRestaurant(status: .orderAhead, popularity: 46)
        let thirdRestaurant = getRestaurant(status: .statusOpen, popularity: 56)
        let fourthRestaurant = getRestaurant(status: .statusOpen, popularity: 65)
        let fifthRestaurant = getRestaurant(status: .orderAhead, popularity: 76)
        let sixthRestaurant = getRestaurant(status: .statusOpen, popularity: 96)

        let restaurants = [firstRestaurant, secondRestaurant, thirdRestaurant, fourthRestaurant, fifthRestaurant, sixthRestaurant]
        let expectedOutput = [sixthRestaurant, fourthRestaurant, thirdRestaurant, fifthRestaurant, secondRestaurant, firstRestaurant]
        assert(searchText: nil, sortType: .popularity, restaurants: restaurants, expectedOutput: expectedOutput)
    }
    
    func test_load_in_sortedOrder_afterApplying_sortingOption_averageProductPrice() {
        let firstRestaurant = getRestaurant( status: .closed, averageProductPrice: 23)
        let secondRestaurant = getRestaurant(status: .orderAhead, averageProductPrice: 46)
        let thirdRestaurant = getRestaurant(status: .statusOpen, averageProductPrice: 56)
        let fourthRestaurant = getRestaurant(status: .statusOpen, averageProductPrice: 65)
        let fifthRestaurant = getRestaurant(status: .orderAhead, averageProductPrice: 76)
        let sixthRestaurant = getRestaurant(status: .statusOpen, averageProductPrice: 96)

        let restaurants = [firstRestaurant, secondRestaurant, thirdRestaurant, fourthRestaurant, fifthRestaurant, sixthRestaurant]
        let expectedOutput = [thirdRestaurant, fourthRestaurant, sixthRestaurant, secondRestaurant, fifthRestaurant, firstRestaurant]
        assert(searchText: nil, sortType: .averageProductPrice, restaurants: restaurants, expectedOutput: expectedOutput)
    }
    
    func test_load_in_sortedOrder_afterApplying_sortingOption_deliveryCosts() {
        let firstRestaurant = getRestaurant( status: .closed, deliveryCosts: 23)
        let secondRestaurant = getRestaurant(status: .orderAhead, deliveryCosts: 46)
        let thirdRestaurant = getRestaurant(status: .statusOpen, deliveryCosts: 56)
        let fourthRestaurant = getRestaurant(status: .statusOpen, deliveryCosts: 65)
        let fifthRestaurant = getRestaurant(status: .orderAhead, deliveryCosts: 76)
        let sixthRestaurant = getRestaurant(status: .statusOpen, deliveryCosts: 96)

        let restaurants = [firstRestaurant, secondRestaurant, thirdRestaurant, fourthRestaurant, fifthRestaurant, sixthRestaurant]
        let expectedOutput = [thirdRestaurant, fourthRestaurant, sixthRestaurant, secondRestaurant, fifthRestaurant, firstRestaurant]
        assert(searchText: nil, sortType: .deliveryCosts, restaurants: restaurants, expectedOutput: expectedOutput)
    }
    
    func test_load_in_sortedOrder_afterApplying_sortingOption_minCost() {
        let firstRestaurant = getRestaurant( status: .closed, minCost: 23)
        let secondRestaurant = getRestaurant(status: .orderAhead, minCost: 46)
        let thirdRestaurant = getRestaurant(status: .statusOpen, minCost: 56)
        let fourthRestaurant = getRestaurant(status: .statusOpen, minCost: 65)
        let fifthRestaurant = getRestaurant(status: .orderAhead, minCost: 76)
        let sixthRestaurant = getRestaurant(status: .statusOpen, minCost: 96)

        let restaurants = [firstRestaurant, secondRestaurant, thirdRestaurant, fourthRestaurant, fifthRestaurant, sixthRestaurant]
        let expectedOutput = [thirdRestaurant, fourthRestaurant, sixthRestaurant, secondRestaurant, fifthRestaurant, firstRestaurant]
        assert(searchText: nil, sortType: .minCost, restaurants: restaurants, expectedOutput: expectedOutput)
    }
    
    func test_resetting_restaurants_after_removing_search() {
        let firstRestaurant = getRestaurant(name:"First", status: .closed)
        let secondRestaurant = getRestaurant(name:"First", status: .orderAhead)
        let thirdRestaurant = getRestaurant(name:"First", status: .statusOpen)
        let fourthRestaurant = getRestaurant(name:"Second", status: .statusOpen)
        let fifthRestaurant = getRestaurant(name:"Second", status: .orderAhead)
        let loader = MockRestaurantsLoader()
        let sut = RestaurantsListViewModel(restaurantLoader: loader, sortTypeManager: getSortTypeManager())
        let expectation = expectation(description: "wait for restaurant to load")
        
        sut.load()
        
        sut.onLoad = {
            sut.sortRestaurantsByNameAndNotify("first")
            sut.removeSearchAndNotify()
            XCTAssertEqual(sut.sortedRestaurantsList, [thirdRestaurant, fourthRestaurant, secondRestaurant, fifthRestaurant, firstRestaurant])
            expectation.fulfill()
        }
                
        loader.complete(with: [firstRestaurant, secondRestaurant, thirdRestaurant, fourthRestaurant, fifthRestaurant])
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_load_success_with_persistant_sortTypeDistance() {
        let firstRestaurant = getRestaurant(status: .closed, distance: 23)
        let secondRestaurant = getRestaurant(status: .orderAhead, distance: 46)
        let thirdRestaurant = getRestaurant(status: .statusOpen, distance: 156)
        let fourthRestaurant = getRestaurant(status: .statusOpen, distance: 165)
        let fifthRestaurant = getRestaurant(status: .orderAhead, distance: 176)
        let sixthRestaurant = getRestaurant(status: .statusOpen, distance: 1296)
                
        assert(restaurants: [firstRestaurant, secondRestaurant, thirdRestaurant, fourthRestaurant, fifthRestaurant, sixthRestaurant], expectedOutput: [thirdRestaurant, fourthRestaurant, sixthRestaurant, secondRestaurant, fifthRestaurant, firstRestaurant], sortTypeManager: MockSortTypesLoader(sortType: .distance))
    }
    
    private func assert(searchText: String? = nil, sortType: SortType? = nil, restaurants: [Restaurant], expectedOutput: [Restaurant], sortTypeManager: SortTypeManager = MockSortTypesLoader()) {
        let expectation = expectation(description: "wait for restaurant to load")
        let loader = MockRestaurantsLoader()
        let sut = RestaurantsListViewModel(restaurantLoader: loader, sortTypeManager: sortTypeManager)
        sut.load()
        if let sortType = sortType {
            sut.onLoad = {
                sut.sortRestaurantsBySortType(sortType)
            }
        } else if let text = searchText {
            sut.onLoad = {
                sut.sortRestaurantsByNameAndNotify(text)
                
            }
        } else {
            sut.onLoad = {
                XCTAssertEqual(sut.sortedRestaurantsList, expectedOutput)
                expectation.fulfill()
            }
        }
        
        sut.onUpdate = {
            XCTAssertEqual(sut.sortedRestaurantsList, expectedOutput)
            expectation.fulfill()
        }
        
        loader.complete(with: restaurants)
        wait(for: [expectation], timeout: 1.0)
    }
    
    private func getSortTypeManager(sortType: SortType? = nil) -> SortTypeManager {
        return MockSortTypesLoader(sortType: sortType)
    }
    
    func test_title() {
        let loader = MockRestaurantsLoader()
        let sut = RestaurantsListViewModel(restaurantLoader: loader, sortTypeManager: MockSortTypesLoader())
        XCTAssertEqual(sut.title, "Restaurants")
    }
}

private final class MockSortTypesLoader: SortTypeManager {
    
    private var sortType: SortType?
    
    init(sortType: SortType? = nil) {
        self.sortType = sortType
    }
    
    func save(_ rawValue: Int) {  }
    
    func getSortType() -> SortType? {
        return sortType
    }
}

private final class MockRestaurantsLoader: RestaurantLoader {
    
    private var completion: ((Result<[Restaurant], Error>) -> Void)?
    
    func load(completion: @escaping (Result<[Restaurant], Error>) -> Void) {
        self.completion = completion
    }
    
    func complete(with restaurant: [Restaurant]) {
        completion?(.success(restaurant))
    }
    
    func complete(with error: Error) {
        completion?(.failure(error))
    }
}
