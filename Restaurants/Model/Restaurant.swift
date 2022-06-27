//
//  Restaurant.swift
//  Restaurants
//
//  Created by Alok Sinha on 2022-06-27.
//

import Foundation

struct Root: Codable {
    let restaurants: [Restaurant]
}
// MARK: - Restaurant
struct Restaurant: Codable, Equatable {
    let name: String
    let status: Status
    let sortingValues: SortingValues
}

// MARK: - SortingValues
struct SortingValues: Codable, Equatable {
    let bestMatch: Float
    let newest: Float
    let ratingAverage: Double
    let distance, popularity, averageProductPrice, deliveryCosts: Float
    let minCost: Float
}

enum Status: String, Codable, Equatable, Comparable {
    case closed = "closed"
    case orderAhead = "order ahead"
    case statusOpen = "open"
    
    private var comparisonValue: Int {
        switch self {
        case .closed:
            return 0
        case .orderAhead:
            return 1
        case .statusOpen:
            return 2
        }
    }
    
    static func < (lhs: Status, rhs: Status) -> Bool {
        return lhs.comparisonValue < rhs.comparisonValue
    }
}
