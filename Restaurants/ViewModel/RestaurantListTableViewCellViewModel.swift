//
//  RestaurantListTableViewCellViewModel.swift
//  Restaurants
//
//  Created by Alok Sinha on 2022-07-01.
//

import Foundation

struct RestaurantListTableViewCellViewModel {
    private let restaurant: Restaurant
    private let sortType: SortType?
    
    init(restaurant: Restaurant, sortType: SortType? = nil) {
        self.restaurant = restaurant
        self.sortType = sortType
    }
    
    var title: String{
        return restaurant.name
    }
    
    var description: String {
        guard let sortType = sortType else {
            return restaurant.status.rawValue.uppercased()
        }
        return "\(restaurant.status.rawValue.uppercased()) ,  \(sortType.description) : \(restaurant.value(sortType))"
    }
}
