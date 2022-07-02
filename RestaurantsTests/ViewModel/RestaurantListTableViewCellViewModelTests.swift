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

        let sut = RestaurantListTableViewCellViewModel(restaurant: firstRestaurant, sortType: .distance)
        XCTAssertEqual(sut.title, firstRestaurant.name)
        XCTAssertEqual(sut.description, "OPEN ,  Distance : 100.0")
    }
    
    func test_title_when_sortingOption_isNil() {
        let firstRestaurant = getRestaurant(name: "Good Food", status: .statusOpen)

        let sut = RestaurantListTableViewCellViewModel(restaurant: firstRestaurant)
        XCTAssertEqual(sut.title, firstRestaurant.name)
        XCTAssertEqual(sut.description, "OPEN")
    }
}
