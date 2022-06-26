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
struct Restaurant: Codable {
    let name: String
    let status: Status
    let sortingValues: SortingValues
}

// MARK: - SortingValues
struct SortingValues: Codable {
    let bestMatch, newest: Int
    let ratingAverage: Double
    let distance, popularity, averageProductPrice, deliveryCosts: Int
    let minCost: Int
}

enum Status: Codable {
    
    case closed
    case orderAhead
    case statusOpen
    
    enum CodingKeys: String, CodingKey {
        case closed = "closed"
        case orderAhead = "orderAhead"
        case statusOpen = "statusOpen"
    }
}
