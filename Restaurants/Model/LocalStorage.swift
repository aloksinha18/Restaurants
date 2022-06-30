//
//  LocalStorage.swift
//  Restaurants
//
//  Created by Alok Sinha on 2022-06-30.
//

import Foundation

protocol SortOptionLoader {
    func save(_ rawValue: Int)
    func getFilter() -> FilterType?
}

protocol LocalStoragePresentable {
    func saveToLocal(_ rawValue: Int)
    func retrieveFilterFromLocal() -> FilterType?
}

struct UserDefaultStorage: LocalStoragePresentable {
    
    let userDefault = UserDefaults.standard
    
    func saveToLocal(_ rawValue: Int) {
        userDefault.set(rawValue, forKey: "sortOption")
    }
    
    func retrieveFilterFromLocal() -> FilterType? {
        if let rawValue =  userDefault.value(forKey: "sortOption") as? Int, let filter = FilterType(rawValue: rawValue) {
            return filter
        }
        return nil
    }
}

struct LocalStorage: SortOptionLoader {
    private let loader: LocalStoragePresentable
    
    init(loader: LocalStoragePresentable) {
        self.loader = loader
    }
    
    func save(_ rawValue: Int) {
        loader.saveToLocal(rawValue)
    }
    
    func getFilter() -> FilterType? {
        loader.retrieveFilterFromLocal()
    }
}
