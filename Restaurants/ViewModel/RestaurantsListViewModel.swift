//
//  RestaurantsListViewModel.swift
//  Restaurants
//
//  Created by Alok Sinha on 2022-06-27.
//

import Foundation

class RestaurantsListViewModel {
    
    private let restaurantLoader: RestaurantLoader
    private let sortTypeManager: SortTypeManager
    
    private var searchInput: String?
    private var restaurants: [Restaurant] = []
    
    var sortedRestaurantsList: [Restaurant] = []
    
    var onLoad: (()-> Void)?
    var onUpdate: (()-> Void)?
    var onFail: ((Error)-> Void)?
    
    private var selectedSortType: SortType?
    
    var title: String {
        "Restaurants"
    }
    
    init(restaurantLoader: RestaurantLoader, sortTypeManager: SortTypeManager) {
        self.restaurantLoader = restaurantLoader
        self.sortTypeManager = sortTypeManager
    }
    
    func load() {
        restaurantLoader.load { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let restaurants):
                let sortedList = self.sortRestaurantsByStatusAndSortOptionIfAny(restaurants: restaurants)
                self.restaurants = sortedList
                self.sortedRestaurantsList = sortedList
                self.onLoad?()
            case .failure(let error):
                self.onFail?(error)
            }
        }
    }
    
    func sortRestaurantsByNameAndNotify(_ input: String)  {
        searchInput = input
        let result = restaurants.filter { $0.name.hasPrefix(input) }
        self.sortedRestaurantsList = result
        onUpdate?()
    }
    
    func sortRestaurantsBySortType(_ sortType: SortType) {
        selectedSortType = sortType
        sortTypeManager.save(sortType.rawValue)
        let result = sortRestaurantsBySortType(sortType, restaurants: restaurants)
        if let searchInput = searchInput {
            let searchedResults  = result.filter { $0.name.hasPrefix(searchInput) }
            sortRestaurantsByStatusAndNotify(restaurants: searchedResults)
        } else {
            sortRestaurantsByStatusAndNotify(restaurants: result)
        }
    }
    
    func removeSearchAndNotify() {
        self.sortedRestaurantsList = restaurants
        self.searchInput = nil
        onUpdate?()
    }
    
    func cellViewModel(for index: IndexPath) -> RestaurantListTableViewCellViewModel {
        RestaurantListTableViewCellViewModel(restaurant: sortedRestaurantsList[index.row], sortType: selectedSortType)
    }
    
    private func sortRestaurantsBySortType(_ sortType: SortType, restaurants: [Restaurant]) -> [Restaurant] {
        restaurants.sorted(by: sortType.predicate())
    }
    
    private func sortRestaurantsByStatusAndNotify(restaurants: [Restaurant]) {
        let finalResult = sortRestaurantsByStatus(restaurants)
        self.sortedRestaurantsList = finalResult
        onUpdate?()
    }
    
    private func sortRestaurantsByStatusAndSortOptionIfAny(restaurants: [Restaurant]) -> [Restaurant] {
        
        guard let sortType = sortTypeManager.getSortType() else {
            let sortedList = self.sortRestaurantsByStatus(restaurants)
            sortedRestaurantsList = sortedList
            return sortedList
        }
        selectedSortType = sortType
        let sortedRestaurantsBySortType = sortRestaurantsBySortType(sortType, restaurants: restaurants)
        return sortRestaurantsByStatus(sortedRestaurantsBySortType)
    }
    
    private func sortRestaurantsByStatus(_ input: [Restaurant]) -> [Restaurant] {
        let restaurants = input.sorted(by: { $0.status > $1.status })
        return restaurants
    }
}
