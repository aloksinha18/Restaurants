//
//  Extensions.swift
//  RestaurantsTests
//
//  Created by Alok Sinha on 2022-07-01.
//

import XCTest
@testable import Restaurants

extension XCTestCase {
    func getRestaurant(name: String = "Restaurant", status: Status, bestMatch: Float = 0.0, newest: Float = 96.0 , ratingAverage: Float = 4.5, distance: Float = 1190, popularity: Float = 17, averageProductPrice: Float = 1536, deliveryCosts: Float = 200, minCost: Float = 1000)-> Restaurant {
        Restaurant(name: name, status: status, sortingValues: SortingValues(bestMatch: bestMatch, newest: newest, ratingAverage: ratingAverage, distance: distance, popularity: popularity, averageProductPrice: averageProductPrice, deliveryCosts: deliveryCosts, minCost: minCost))
    }
    
    func anyNSError() -> NSError {
        NSError(domain: "Test", code: 404)
    }
}
