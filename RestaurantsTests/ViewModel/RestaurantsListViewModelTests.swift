//
//  RestaurantsListViewModel.swift
//  RestaurantsTests
//
//  Created by Alok Sinha on 2022-06-27.
//

import XCTest
@testable import Restaurants

final class RestaurantsListViewModelTests: XCTestCase {
    
    func test_load_in_sorted_order() {
        
        let firstRestaurant = getRestaurant(with: "First Restaurant", status: .closed)
        let secondRestaurant = getRestaurant(with: "Second Restaurant", status: .statusOpen)
        let thirdRestaurant = getRestaurant(with: "Third Restaurant", status: .orderAhead)
        
        let sut = RestaurantsListViewModel(restaurants: [firstRestaurant, secondRestaurant, thirdRestaurant])
        
        XCTAssertEqual(sut.sortedRestaurants[0].status, .statusOpen)
        XCTAssertEqual(sut.sortedRestaurants[1].status, .orderAhead)
        XCTAssertEqual(sut.sortedRestaurants[2].status, .closed)
    }
    
    func test_load_in_sorted_order_after_search() {
        let firstClosedRestaurant = getRestaurant(with: "First Restaurant", status: .closed)
        let firstOpenRestaurant = getRestaurant(with: "First Restaurant", status: .orderAhead)
        let firstOrderaheadRestaurant = getRestaurant(with: "First Restaurant", status: .statusOpen)
        let secondRestaurant = getRestaurant(with: "Second Restaurant", status: .statusOpen)
        let thirdRestaurant = getRestaurant(with: "Third Restaurant", status: .orderAhead)
        let sut = RestaurantsListViewModel(restaurants: [firstClosedRestaurant,firstOpenRestaurant,firstOrderaheadRestaurant, secondRestaurant, thirdRestaurant])
        
        sut.sortedRestaurantsByName("First")
        XCTAssertEqual(sut.sortedRestaurants.count, 3)
        XCTAssertEqual(sut.sortedRestaurants[0].status, .statusOpen)
        XCTAssertEqual(sut.sortedRestaurants[1].status, .orderAhead)
        XCTAssertEqual(sut.sortedRestaurants[2].status, .closed)
    }
    
    private func getRestaurant(with name: String, status: Status)-> Restaurant {
        Restaurant(name: name, status: status, sortingValues: SortingValues(bestMatch: 0.0, newest: 96.0, ratingAverage: 4.5, distance: 1190, popularity: 17, averageProductPrice: 1536, deliveryCosts: 200, minCost: 1000))
    }
}
