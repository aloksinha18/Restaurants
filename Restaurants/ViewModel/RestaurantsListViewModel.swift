//
//  RestaurantsListViewModel.swift
//  Restaurants
//
//  Created by Alok Sinha on 2022-06-27.
//

import Foundation

class RestaurantsListViewModel {
    
    private var restaurants: [Restaurant]
    
    init(restaurants: [Restaurant]) {
        self.restaurants = restaurants
    }
    
    var sortedRestaurants: [Restaurant] {
        sortRestaurantsByStatus(restaurants)
    }
    
    private func sortRestaurantsByStatus(_ restaurant: [Restaurant]) -> [Restaurant] {
        restaurants = restaurant.sorted(by: { $0.status > $1.status })
        return restaurants
    }
    
    func sortedRestaurantsByName(_ input: String)  {
        restaurants = restaurants.filter { $0.name.localizedCaseInsensitiveContains(input) }
    }
}
