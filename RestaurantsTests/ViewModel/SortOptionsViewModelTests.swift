//
//  FilterListViewModelTests.swift
//  RestaurantsTests
//
//  Created by Alok Sinha on 2022-06-28.
//

import XCTest
@testable import Restaurants

final class SortOptionsViewModelTests: XCTestCase {
    func test_sut_has_all_sortItems() {
        let sut = SortingOptionsListViewModel()
        XCTAssertEqual(sut.sortingOptions, [.bestMatch, .newest, .ratingAverage, .distance, .popularity, .averageProductPrice, .deliveryCosts, .minCost])
    }
}
