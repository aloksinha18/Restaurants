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
        test(restaurants: [firstRestaurant, secondRestaurant, thirdRestaurant], expectedOutput: [secondRestaurant, thirdRestaurant, firstRestaurant])
    }
    
    func test_load_fails() {
        let loader = MockRestaurantsLoader()
        let sut = RestaurantsListViewModel(loader: loader)
        sut.load()
        let expectation = expectation(description: "wait for restaurant to load")
        sut.onFail = { error in
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        loader.complete(with: anyNSError())
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_load_in_sorted_order_after_search() {
        let firstClosedRestaurant = getRestaurant(with: "First Restaurant", status: .closed)
        let firstOpenRestaurant = getRestaurant(with: "First Restaurant", status: .orderAhead)
        let firstOrderaheadRestaurant = getRestaurant(with: "First Restaurant", status: .statusOpen)
        let secondRestaurant = getRestaurant(with: "Second Restaurant", status: .statusOpen)
        let thirdRestaurant = getRestaurant(with: "Third Restaurant", status: .orderAhead)
        let restaurants = [firstClosedRestaurant,firstOpenRestaurant,firstOrderaheadRestaurant, secondRestaurant, thirdRestaurant]
        test("First", nil, restaurants: restaurants, expectedOutput: [firstOrderaheadRestaurant, firstOpenRestaurant, firstClosedRestaurant])
    }

    func test_load_in_sorted_order_after_applying_sortingOption_bestMatch() {
        let firstClosedRestaurant = getRestaurant( status: .closed, bestMatch: 23)
        let firstOrderaheadRestaurant = getRestaurant(status: .orderAhead, bestMatch: 46)
        let firstOpenRestaurant = getRestaurant(status: .statusOpen, bestMatch: 56)
        let secondRestaurant = getRestaurant(status: .statusOpen, bestMatch: 65)
        let thirdRestaurant = getRestaurant(status: .orderAhead, bestMatch: 76)
        let fourthRestaurant = getRestaurant(status: .statusOpen, bestMatch: 96)

        let restaurants = [firstClosedRestaurant,firstOpenRestaurant,firstOrderaheadRestaurant, secondRestaurant, thirdRestaurant, fourthRestaurant]
        let expectedOutput = [fourthRestaurant, secondRestaurant, firstOpenRestaurant, thirdRestaurant, firstOrderaheadRestaurant, firstClosedRestaurant]
        test(nil, .bestMatch, restaurants: restaurants, expectedOutput: expectedOutput)
    }

    private func test(_ searchText: String? = nil, _ sortOptions: FilterType? = nil, restaurants: [Restaurant], expectedOutput: [Restaurant]) {
        let expectation = expectation(description: "wait for restaurant to load")
        let loader = MockRestaurantsLoader()
        let sut = RestaurantsListViewModel(loader: loader)
        sut.load()
        if let option = sortOptions {
            sut.onLoad = {
                sut.sortedResultsBySortOption(option)
                expectation.fulfill()
            }
        } else if let text = searchText {
            sut.onLoad = {
                sut.sortedRestaurantsByNameAndNotify(text)
                expectation.fulfill()
            }
        } else {
            expectation.fulfill()
        }
        
        loader.complete(with: restaurants)
        XCTAssertEqual(sut.filteredList, expectedOutput)
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_load_in_sorted_order_after_applying_sortingOption_newest() {
        let firstClosedRestaurant = getRestaurant(status: .closed, newest: 23)
        let firstOrderaheadRestaurant = getRestaurant(status: .orderAhead, newest: 46)
        let firstOpenRestaurant = getRestaurant(status: .statusOpen, newest: 56)
        let secondRestaurant = getRestaurant(status: .statusOpen, newest: 65)
        let thirdRestaurant = getRestaurant(status: .orderAhead, newest: 76)
        let fourthRestaurant = getRestaurant(status: .statusOpen, newest: 96)

        let restaurants = [firstClosedRestaurant,firstOpenRestaurant,firstOrderaheadRestaurant, secondRestaurant, thirdRestaurant, fourthRestaurant]
        test(nil, .newest, restaurants: restaurants, expectedOutput: [fourthRestaurant, secondRestaurant, firstOpenRestaurant, thirdRestaurant, firstOrderaheadRestaurant, firstClosedRestaurant])
    }
    
    func test_load_in_sorted_order_after_applying_sortingOption_ratingAverage() {
        let firstClosedRestaurant = getRestaurant(status: .closed, ratingAverage: 23)
        let firstOrderaheadRestaurant = getRestaurant(status: .orderAhead, ratingAverage: 46)
        let firstOpenRestaurant = getRestaurant(status: .statusOpen, ratingAverage: 56)
        let secondRestaurant = getRestaurant(status: .statusOpen, ratingAverage: 65)
        let thirdRestaurant = getRestaurant(status: .orderAhead, ratingAverage: 76)
        let fourthRestaurant = getRestaurant(status: .statusOpen, ratingAverage: 96)

        let restaurants = [firstClosedRestaurant,firstOpenRestaurant,firstOrderaheadRestaurant, secondRestaurant, thirdRestaurant, fourthRestaurant]
        test(nil, .ratingAverage, restaurants: restaurants, expectedOutput: [fourthRestaurant, secondRestaurant, firstOpenRestaurant, thirdRestaurant, firstOrderaheadRestaurant, firstClosedRestaurant])
    }
    
    func test_load_in_sorted_order_after_applying_sortingOption_distance() {
        let firstClosedRestaurant = getRestaurant(status: .closed, distance: 23)
        let firstOrderaheadRestaurant = getRestaurant(status: .orderAhead, distance: 46)
        let firstOpenRestaurant = getRestaurant(status: .statusOpen, distance: 156)
        let secondRestaurant = getRestaurant(status: .statusOpen, distance: 165)
        let thirdRestaurant = getRestaurant(status: .orderAhead, distance: 176)
        let fourthRestaurant = getRestaurant(status: .statusOpen, distance: 1296)

        let restaurants = [firstClosedRestaurant,firstOpenRestaurant,firstOrderaheadRestaurant, secondRestaurant, thirdRestaurant, fourthRestaurant]
        test(nil, .distance, restaurants: restaurants, expectedOutput: [firstOpenRestaurant, secondRestaurant, fourthRestaurant, firstOrderaheadRestaurant, thirdRestaurant, firstClosedRestaurant])
    }
    
    func test_load_in_sorted_order_after_applying_sortingOption_popularity() {
        let firstClosedRestaurant = getRestaurant(status: .closed, popularity: 23)
        let firstOrderaheadRestaurant = getRestaurant(status: .orderAhead, popularity: 46)
        let firstOpenRestaurant = getRestaurant(status: .statusOpen, popularity: 156)
        let secondRestaurant = getRestaurant(status: .statusOpen, popularity: 165)
        let thirdRestaurant = getRestaurant(status: .orderAhead, popularity: 176)
        let fourthRestaurant = getRestaurant(status: .statusOpen, popularity: 1296)

        let restaurants = [firstClosedRestaurant,firstOpenRestaurant,firstOrderaheadRestaurant, secondRestaurant, thirdRestaurant, fourthRestaurant]
        test(nil, .popularity, restaurants: restaurants, expectedOutput: [fourthRestaurant, secondRestaurant, firstOpenRestaurant, thirdRestaurant, firstOrderaheadRestaurant, firstClosedRestaurant])
    }
    
    func test_load_in_sorted_order_after_applying_sortingOption_averageProductPrice() {
        let firstClosedRestaurant = getRestaurant(status: .closed, averageProductPrice: 23)
        let firstOrderaheadRestaurant = getRestaurant(status: .orderAhead, averageProductPrice: 46)
        let firstOpenRestaurant = getRestaurant(status: .statusOpen, averageProductPrice: 156)
        let secondRestaurant = getRestaurant(status: .statusOpen, averageProductPrice: 165)
        let thirdRestaurant = getRestaurant(status: .orderAhead, averageProductPrice: 176)
        let fourthRestaurant = getRestaurant(status: .statusOpen, averageProductPrice: 1296)

        let restaurants = [firstClosedRestaurant,firstOpenRestaurant,firstOrderaheadRestaurant, secondRestaurant, thirdRestaurant, fourthRestaurant]
        test(nil, .averageProductPrice, restaurants: restaurants, expectedOutput: [firstOpenRestaurant, secondRestaurant, fourthRestaurant, firstOrderaheadRestaurant, thirdRestaurant, firstClosedRestaurant])
    }
    
    func test_load_in_sorted_order_after_applying_sortingOption_deliveryCosts() {
        let firstClosedRestaurant = getRestaurant(status: .closed, deliveryCosts: 23)
        let firstOrderaheadRestaurant = getRestaurant(status: .orderAhead, deliveryCosts: 46)
        let firstOpenRestaurant = getRestaurant(status: .statusOpen, deliveryCosts: 156)
        let secondRestaurant = getRestaurant(status: .statusOpen, deliveryCosts: 165)
        let thirdRestaurant = getRestaurant(status: .orderAhead, deliveryCosts: 176)
        let fourthRestaurant = getRestaurant(status: .statusOpen, deliveryCosts: 1296)

        let restaurants = [firstClosedRestaurant,firstOpenRestaurant,firstOrderaheadRestaurant, secondRestaurant, thirdRestaurant, fourthRestaurant]
        test(nil, .deliveryCosts, restaurants: restaurants, expectedOutput: [firstOpenRestaurant, secondRestaurant, fourthRestaurant, firstOrderaheadRestaurant, thirdRestaurant, firstClosedRestaurant])
    }
    
    func test_load_in_sorted_order_after_applying_sortingOption_minCost() {
        let firstClosedRestaurant = getRestaurant(status: .closed, minCost: 23)
        let firstOrderaheadRestaurant = getRestaurant(status: .orderAhead, minCost: 46)
        let firstOpenRestaurant = getRestaurant(status: .statusOpen, minCost: 156)
        let secondRestaurant = getRestaurant(status: .statusOpen, minCost: 165)
        let thirdRestaurant = getRestaurant(status: .orderAhead, minCost: 176)
        let fourthRestaurant = getRestaurant(status: .statusOpen, minCost: 1296)

        let restaurants = [firstClosedRestaurant,firstOpenRestaurant,firstOrderaheadRestaurant, secondRestaurant, thirdRestaurant, fourthRestaurant]
        test(nil, .minCost, restaurants: restaurants, expectedOutput: [firstOpenRestaurant, secondRestaurant, fourthRestaurant, firstOrderaheadRestaurant, thirdRestaurant, firstClosedRestaurant])
    }
    
    func test_resetting_restaurants_after_removing_search() {
        let firstClosedRestaurant = getRestaurant(status: .closed)
        let firstOpenRestaurant = getRestaurant(status: .orderAhead)
        let firstOrderaheadRestaurant = getRestaurant(status: .statusOpen)
        let secondRestaurant = getRestaurant(status: .statusOpen)
        let thirdRestaurant = getRestaurant(status: .orderAhead)
        let loader = MockRestaurantsLoader()
        let sut = RestaurantsListViewModel(loader: loader)
        let expectation = expectation(description: "wait for restaurant to load")
        
        sut.load()
        
        sut.onLoad = {
            sut.sortedRestaurantsByNameAndNotify("first")
            sut.removeSearchAndNotify()
            XCTAssertEqual(sut.filteredList, [firstOrderaheadRestaurant,secondRestaurant,firstOpenRestaurant, thirdRestaurant, firstClosedRestaurant])
            expectation.fulfill()
        }
                
        loader.complete(with: [firstClosedRestaurant,firstOpenRestaurant,firstOrderaheadRestaurant, secondRestaurant, thirdRestaurant])
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    private func getRestaurant(with name: String = "Restaurant", status: Status, bestMatch: Float = 0.0, newest: Float = 96.0 , ratingAverage: Float = 4.5, distance: Float = 1190, popularity: Float = 17, averageProductPrice: Float = 1536, deliveryCosts: Float = 200, minCost: Float = 1000)-> Restaurant {
        Restaurant(name: name, status: status, sortingValues: SortingValues(bestMatch: bestMatch, newest: newest, ratingAverage: ratingAverage, distance: distance, popularity: popularity, averageProductPrice: averageProductPrice, deliveryCosts: deliveryCosts, minCost: minCost))
    }
    
    private func anyNSError() -> NSError {
        NSError(domain: "Test", code: 404)
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
