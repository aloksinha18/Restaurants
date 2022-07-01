//
//  RestaurantsListViewModel.swift
//  Restaurants
//
//  Created by Alok Sinha on 2022-06-27.
//

import Foundation

class RestaurantsListViewModel {
    
    private let loader: RestaurantLoader
    private let sortingOptionsManager: SortingOptionsManager
    
    private var searchInput: String?
    private var restaurants: [Restaurant] = []
    
    var filteredList: [Restaurant] = []
    
    var onLoad: (()-> Void)?
    var onUpdate: (()-> Void)?
    var onFail: ((Error)-> Void)?
    
    var selectedSortingOption: SortingOptionType?
    
    var title: String {
        "Restaurants"
    }
    
    init(loader: RestaurantLoader, sortingOptionsManager: SortingOptionsManager) {
        self.loader = loader
        self.sortingOptionsManager = sortingOptionsManager
    }
    
    func load() {
        loader.load { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let restaurants):
                let sortedList = self.sortRestaurantsByStatusAndSortOptionIfAny(input: restaurants)
                self.restaurants = sortedList
                self.filteredList = sortedList
                self.onLoad?()
            case .failure(let error):
                self.onFail?(error)
            }
        }
    }
    
    
    func sortRestaurantsByNameAndNotify(_ input: String)  {
        searchInput = input
        let result = restaurants.filter { $0.name.hasPrefix(input) }
        self.filteredList = result
        onUpdate?()
    }
    
    func sortRestaurantsBySortOption(_ input: SortingOptionType) {
        selectedSortingOption = input
        sortingOptionsManager.save(input.rawValue)
        let result = sortRestaurantsByFilterType(input, input: restaurants)
        if let searchInput = searchInput {
            let searchedResults  = result.filter { $0.name.hasPrefix(searchInput) }
            sortRestaurantsByStatusAndNotify(input: searchedResults)
        } else {
            sortRestaurantsByStatusAndNotify(input: result)
        }
    }
    
    func removeSearchAndNotify() {
        self.filteredList = restaurants
        self.searchInput = nil
        onUpdate?()
    }
    
    func cellViewModel(for index: IndexPath) -> RestaurantListTableViewCellViewModel {
        RestaurantListTableViewCellViewModel(restaurant: filteredList[index.row], sortingOptionType: selectedSortingOption)
    }
    
    private func sortRestaurantsByFilterType(_ filterType: SortingOptionType, input: [Restaurant]) -> [Restaurant] {
        input.sorted(by: filterType.predicate())
    }
    
    private func sortRestaurantsByStatusAndNotify(input: [Restaurant]) {
        let finalResult = sortRestaurantsByStatus(input)
        self.filteredList = finalResult
        onUpdate?()
    }
    
    private func sortRestaurantsByStatusAndSortOptionIfAny(input: [Restaurant]) -> [Restaurant] {
        
        guard let sortOption = sortingOptionsManager.getSortingOption() else {
            let sortedList = self.sortRestaurantsByStatus(input)
            filteredList = sortedList
            return sortedList
        }
        selectedSortingOption = sortOption
        let sortByOptions = sortRestaurantsByFilterType(sortOption, input: input)
        return sortRestaurantsByStatus(sortByOptions)
    }
    
    private func sortRestaurantsByStatus(_ input: [Restaurant]) -> [Restaurant] {
        let restaurants = input.sorted(by: { $0.status > $1.status })
        return restaurants
    }
}
