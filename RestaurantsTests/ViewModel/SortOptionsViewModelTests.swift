//
//  FilterListViewModelTests.swift
//  RestaurantsTests
//
//  Created by Alok Sinha on 2022-06-28.
//

import XCTest
@testable import Restaurants

final class SortOptionsViewModelTests: XCTestCase {
    func test_All_filter_items() {
        let sut = SortOptionsViewModel()
        XCTAssertEqual(sut.filters, [.bestMatch, .newest, .ratingAverage, .distance, .popularity, .averageProductPrice, .deliveryCosts, .minCost])
    }
}
