//
//  SortListViewModel.swift
//  Restaurants
//
//  Created by Alok Sinha on 2022-06-28.
//

import Foundation

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
    
    var description: String {
        switch self {
        case .bestMatch:
            return "Best match"
        case .newest:
            return "Newest"
        case .ratingAverage:
            return "Rating average"
        case .distance:
            return "Distance"
        case .popularity:
            return "Popularity"
        case .averageProductPrice:
            return "Average product price"
        case .deliveryCosts:
            return "Delivery costs"
        case .minCost:
            return "Minimum cost"
        }
    }
}

struct SortListViewModel {
    var filters = FilterType.allCases
}
