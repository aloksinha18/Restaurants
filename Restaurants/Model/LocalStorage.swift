//
//  LocalStorage.swift
//  Restaurants
//
//  Created by Alok Sinha on 2022-06-30.
//

import Foundation

protocol SortOptionLoader {
    func save(_ filter: FilterType)
    func getFilter() -> FilterType?
}

protocol LocalStoragePresentable {
    func saveToLocal(_ filter: FilterType)
    func retrieveFilterFromLocal() -> FilterType?
}

struct UserDefaultStorage: LocalStoragePresentable {
    
    let userDefault = UserDefaults.standard
    
    func saveToLocal(_ filter: FilterType) {
        userDefault.set(filter, forKey: "sortOption")
    }
    
    func retrieveFilterFromLocal() -> FilterType? {
        if let value =  userDefault.value(forKey: "sortOption") as? FilterType {
            return value
        }
        return nil
    }
}

struct LocalStorage: SortOptionLoader {
    private let loader: LocalStoragePresentable
    
    init(loader: LocalStoragePresentable) {
        self.loader = loader
    }
    
    func save(_ filter: FilterType) {
        loader.saveToLocal(filter)
    }
    
    func getFilter() -> FilterType? {
        loader.retrieveFilterFromLocal()
    }
}
