//
//  FilterListViewModelTests.swift
//  RestaurantsTests
//
//  Created by Alok Sinha on 2022-06-28.
//

import XCTest
@testable import Restaurants

final class SortOptionsViewModelTests: XCTestCase {
    func test_viewModel_has_allSortingItems() {
        let sut = SortingOptionsListViewModel()
        XCTAssertEqual(sut.sortingOptions, [.bestMatch, .newest, .ratingAverage, .distance, .popularity, .averageProductPrice, .deliveryCosts, .minCost])
    }
    
    func test_title() {
        let sut = SortingOptionsListViewModel()
        XCTAssertEqual(sut.title, "Sorting Options")
    }
}
