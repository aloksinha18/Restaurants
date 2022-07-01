//
//  RestaurantListTableViewCellViewModel.swift
//  Restaurants
//
//  Created by Alok Sinha on 2022-07-01.
//

import Foundation

struct RestaurantListTableViewCellViewModel {
    private let restaurant: Restaurant
    private let sortingOptionType: SortingOptionType?
    
    init(restaurant: Restaurant, sortingOptionType: SortingOptionType? = nil) {
        self.restaurant = restaurant
        self.sortingOptionType = sortingOptionType
    }
    
    var title: String{
        return restaurant.name
    }
    
    var description: String {
        guard let sortingOptionType = sortingOptionType else {
            return restaurant.status.rawValue.uppercased()
        }
        return "\(restaurant.status.rawValue.uppercased()) ,  \(sortingOptionType.description) : \(restaurant.value(sortingOptionType))"
    }
}
