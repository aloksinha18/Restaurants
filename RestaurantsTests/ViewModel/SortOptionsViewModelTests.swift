//
//  SortTypeListViewModelTests.swift
//  RestaurantsTests
//
//  Created by Alok Sinha on 2022-06-28.
//

import XCTest
@testable import Restaurants

final class SortTypeListViewModelTests: XCTestCase {
    func test_viewModel_has_allSortingItems() {
        let sut = SortTypeListViewModel()
        XCTAssertEqual(sut.sortTypes, [.bestMatch, .newest, .ratingAverage, .distance, .popularity, .averageProductPrice, .deliveryCosts, .minCost])
    }
    
    func test_title() {
        let sut = SortTypeListViewModel()
        XCTAssertEqual(sut.title, "Sorting Options")
    }
}
