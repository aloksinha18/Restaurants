//
//  RestaurantsListViewModel.swift
//  Restaurants
//
//  Created by Alok Sinha on 2022-06-27.
//

import Foundation

class RestaurantsListViewModel {
    
    private let loader: RestaurantLoader
    private var restaurants: [Restaurant] = []
    
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
                let sortedList = sortRestaurantsByStatus(restaurants)
                self.restaurants = sortedList
                onLoad?(sortedList)
            case .failure(let error):
                onFail?(error)
            }
        }
    }
    
    private func sortRestaurantsByStatus(_ restaurants: [Restaurant]) -> [Restaurant] {
        let restaurants = restaurants.sorted(by: { $0.status > $1.status })
        return restaurants
    }
    
    func sortedRestaurantsByName(_ input: String)  {
        let restaurants = restaurants.filter { $0.name.localizedCaseInsensitiveContains(input) }
        onLoad?(restaurants)
    }
    
    func removeSearch() {
        let restaurants = restaurants.sorted(by: { $0.status > $1.status })
        self.restaurants = restaurants
        onLoad?(restaurants)
    }
}
