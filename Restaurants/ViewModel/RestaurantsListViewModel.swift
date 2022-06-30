//
//  RestaurantsListViewModel.swift
//  Restaurants
//
//  Created by Alok Sinha on 2022-06-27.
//

import Foundation

class RestaurantsListViewModel {
    
    private let loader: RestaurantLoader
    private let sortOptionLoader: SortOptionLoader

    private var searchInput: String?
    private var restaurants: [Restaurant] = []
    
    var filteredList: [Restaurant] = []
    
    var onLoad: (()-> Void)?
    var onUpdate: (()-> Void)?
    var onFail: ((Error)-> Void)?
    
    var selectedSortOption: FilterType?
    
    init(loader: RestaurantLoader, sortOptionLoader: SortOptionLoader) {
        self.loader = loader
        self.sortOptionLoader = sortOptionLoader
    }
    
    func load() {
        loader.load { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let restaurants):
                let sortedList = self.sortByStatusAndSortOption(input: restaurants)
                self.restaurants = sortedList
                self.filteredList = sortedList
                self.onLoad?()
            case .failure(let error):
                self.onFail?(error)
            }
        }
    }
    
    private func sortByStatusAndSortOption(input: [Restaurant]) -> [Restaurant] {
        
        guard let sortOption = sortOptionLoader.getFilter() else {
            let sortedList = self.sortRestaurantsByStatus(input)
            filteredList = sortedList
            return sortedList
        }
        selectedSortOption = sortOption
        let sortByOptions = sortByFilterType(sortOption, input: input)
        return sortRestaurantsByStatus(sortByOptions)
    }
    
    private func sortRestaurantsByStatus(_ input: [Restaurant]) -> [Restaurant] {
        let restaurants = input.sorted(by: { $0.status > $1.status })
        return restaurants
    }
    
    func sortedRestaurantsByNameAndNotify(_ input: String)  {
        searchInput = input
        let result = restaurants.filter { $0.name.hasPrefix(input) }
        self.filteredList = result
        onUpdate?()
    }
    
    func sortedResultsBySortOption(_ input: FilterType) {
        selectedSortOption = input
        sortOptionLoader.save(input.rawValue)
        let result = sortByFilterType(input, input: restaurants)
        if let searchInput = searchInput {
            let searchedResults  = result.filter { $0.name.hasPrefix(searchInput) }
            sortByStatusAndNotify(input: searchedResults)
        } else {
            sortByStatusAndNotify(input: result)
        }
    }
    
    private func sortByFilterType(_ filterType: FilterType, input: [Restaurant]) -> [Restaurant] {
        input.sorted(by: filterType.predicate())
    }
    
    private func sortByStatusAndNotify(input: [Restaurant]) {
        let finalResult = sortRestaurantsByStatus(input)
        self.filteredList = finalResult
        onUpdate?()
    }
    
    func removeSearchAndNotify() {
        self.filteredList = restaurants
        self.searchInput = nil
        onUpdate?()
    }
}
