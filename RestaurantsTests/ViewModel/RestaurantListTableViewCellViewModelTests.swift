//
//  RestaurantListTableViewCellTests.swift
//  RestaurantsTests
//
//  Created by Alok Sinha on 2022-07-01.
//

import XCTest
@testable import Restaurants

final class RestaurantListTableViewCellViewModelTests: XCTestCase {

    func test_title_when_sortingOption_isNotNil() {
        let firstRestaurant = getRestaurant(name: "Good Food", status: .statusOpen, distance: 100)

        let sut = RestaurantListTableViewCellViewModel(restaurant: firstRestaurant, sortingOptionType: .distance)
        XCTAssertEqual(sut.title, firstRestaurant.name)
        XCTAssertEqual(sut.description, "OPEN ,  Distance : 100.0")
    }
    
    func test_title_when_sortingOption_isNil() {
        let firstRestaurant = getRestaurant(name: "Good Food", status: .statusOpen)

        let sut = RestaurantListTableViewCellViewModel(restaurant: firstRestaurant)
        XCTAssertEqual(sut.title, firstRestaurant.name)
        XCTAssertEqual(sut.description, "OPEN")
    }

    
    private func getRestaurant(name: String = "Restaurant", status: Status, bestMatch: Float = 0.0, newest: Float = 96.0 , ratingAverage: Float = 4.5, distance: Float = 1190, popularity: Float = 17, averageProductPrice: Float = 1536, deliveryCosts: Float = 200, minCost: Float = 1000)-> Restaurant {
        Restaurant(name: name, status: status, sortingValues: SortingValues(bestMatch: bestMatch, newest: newest, ratingAverage: ratingAverage, distance: distance, popularity: popularity, averageProductPrice: averageProductPrice, deliveryCosts: deliveryCosts, minCost: minCost))
    }
}
