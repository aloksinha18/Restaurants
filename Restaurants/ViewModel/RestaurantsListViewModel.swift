//
//  RestaurantsListViewModel.swift
//  Restaurants
//
//  Created by Alok Sinha on 2022-06-27.
//

import Foundation

class RestaurantsListViewModel {
    
    private let loader: RestaurantLoader
    var restaurants: [Restaurant] = []
    var filteredList: [Restaurant] = []

    
    var onLoad: (([Restaurant])-> Void)?
    var onFail: ((Error)-> Void)?
    
    init(loader: RestaurantLoader) {
        self.loader = loader
    }
    
    func load() {
        loader.load { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let restaurants):
                let sortedList = self.sortRestaurantsByStatus(restaurants)
                self.restaurants = sortedList
                self.filteredList = sortedList
                self.onLoad?(sortedList)
            case .failure(let error):
                self.onFail?(error)
            }
        }
    }
    
    private func sortRestaurantsByStatus(_ restaurants: [Restaurant]) -> [Restaurant] {
        let restaurants = restaurants.sorted(by: { $0.status > $1.status })
        return restaurants
    }
    
    func sortedRestaurantsByName(_ input: String)  {
        let result = restaurants.filter { $0.name.hasPrefix(input) }
        self.filteredList = result
        onLoad?(result)
    }
    
    func removeSearch() {
        let result = restaurants.sorted(by: { $0.status > $1.status })
        self.restaurants = result
        self.filteredList = result
        onLoad?(result)
    }
}
