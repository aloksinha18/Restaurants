//
//  FilterListViewModelTests.swift
//  RestaurantsTests
//
//  Created by Alok Sinha on 2022-06-28.
//

import XCTest
@testable import Restaurants

enum FilterType: CaseIterable {
    case bestMatch
    case newest
    case ratingAverage
    case distance
    case popularity
    case averageProductPrice
    case deliveryCosts
    case minCost

    func predicate() -> ((Restaurant, Restaurant) -> Bool) {
        switch self {
        case .bestMatch:
            return { $0.sortingValues.bestMatch > $1.sortingValues.bestMatch }
        case .newest:
            return { $0.sortingValues.newest > $1.sortingValues.newest }
        case .ratingAverage:
            return { $0.sortingValues.ratingAverage > $1.sortingValues.ratingAverage }
        case .distance:
            return { $0.sortingValues.distance > $1.sortingValues.distance }
        case .popularity:
            return { $0.sortingValues.popularity > $1.sortingValues.popularity }
        case .averageProductPrice:
            return { $0.sortingValues.averageProductPrice > $1.sortingValues.averageProductPrice }
        case .deliveryCosts:
            return { $0.sortingValues.deliveryCosts > $1.sortingValues.deliveryCosts }
        case .minCost:
            return { $0.sortingValues.minCost > $1.sortingValues.minCost }
        }
    }
}

struct FilterListViewModel {
    var filters = FilterType.allCases
}

final class FilterListViewModelTests: XCTestCase {
    func test_All_filter_items() {
        let sut = FilterListViewModel()
        XCTAssertEqual(sut.filters, [.bestMatch, .newest, .ratingAverage, .distance, .popularity, .averageProductPrice, .deliveryCosts, .minCost])
    }
}
