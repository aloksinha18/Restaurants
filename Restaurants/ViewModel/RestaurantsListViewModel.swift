//
//  RestaurantsListViewModel.swift
//  Restaurants
//
//  Created by Alok Sinha on 2022-06-27.
//

import Foundation

class RestaurantsListViewModel {
    
    private let restaurantLoader: RestaurantLoader
    private let sortingOptionsManager: SortingOptionsManager
    
    private var searchInput: String?
    private var restaurants: [Restaurant] = []
    
    var sortedRestaurantsList: [Restaurant] = []
    
    var onLoad: (()-> Void)?
    var onUpdate: (()-> Void)?
    var onFail: ((Error)-> Void)?
    
    var selectedSortingOption: SortingOptionType?
    
    var title: String {
        "Restaurants"
    }
    
    init(restaurantLoader: RestaurantLoader, sortingOptionsManager: SortingOptionsManager) {
        self.restaurantLoader = restaurantLoader
        self.sortingOptionsManager = sortingOptionsManager
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
    
    func sortRestaurantsBySortOption(_ sortingOptionType: SortingOptionType) {
        selectedSortingOption = sortingOptionType
        sortingOptionsManager.save(sortingOptionType.rawValue)
        let result = sortRestaurantsByFilterType(sortingOptionType, restaurants: restaurants)
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
        RestaurantListTableViewCellViewModel(restaurant: sortedRestaurantsList[index.row], sortingOptionType: selectedSortingOption)
    }
    
    private func sortRestaurantsByFilterType(_ filterType: SortingOptionType, restaurants: [Restaurant]) -> [Restaurant] {
        restaurants.sorted(by: filterType.predicate())
    }
    
    private func sortRestaurantsByStatusAndNotify(restaurants: [Restaurant]) {
        let finalResult = sortRestaurantsByStatus(restaurants)
        self.sortedRestaurantsList = finalResult
        onUpdate?()
    }
    
    private func sortRestaurantsByStatusAndSortOptionIfAny(restaurants: [Restaurant]) -> [Restaurant] {
        
        guard let sortOption = sortingOptionsManager.getSortingOption() else {
            let sortedList = self.sortRestaurantsByStatus(restaurants)
            sortedRestaurantsList = sortedList
            return sortedList
        }
        selectedSortingOption = sortOption
        let sortByOptions = sortRestaurantsByFilterType(sortOption, restaurants: restaurants)
        return sortRestaurantsByStatus(sortByOptions)
    }
    
    private func sortRestaurantsByStatus(_ input: [Restaurant]) -> [Restaurant] {
        let restaurants = input.sorted(by: { $0.status > $1.status })
        return restaurants
    }
}
