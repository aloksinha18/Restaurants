//
//  LocalStorage.swift
//  Restaurants
//
//  Created by Alok Sinha on 2022-06-30.
//

import Foundation

protocol SortingOptionsManager {
    func save(_ rawValue: Int)
    func getSortingOption() -> SortingOptionType?
}

protocol LocalStoragePresentable {
    func saveToLocal(_ rawValue: Int)
    func retrieveSortingOptionFromLocal() -> SortingOptionType?
}

struct UserDefaultStorage: LocalStoragePresentable {
    
    let userDefault = UserDefaults.standard
    
    func saveToLocal(_ rawValue: Int) {
        userDefault.set(rawValue, forKey: "sortOption")
    }
    
    func retrieveSortingOptionFromLocal() -> SortingOptionType? {
        if let rawValue =  userDefault.value(forKey: "sortOption") as? Int, let filter = SortingOptionType(rawValue: rawValue) {
            return filter
        }
        return nil
    }
}

struct LocalStorage: SortingOptionsManager {
    private let loader: LocalStoragePresentable
    
    init(loader: LocalStoragePresentable) {
        self.loader = loader
    }
    
    func save(_ rawValue: Int) {
        loader.saveToLocal(rawValue)
    }
    
    func getSortingOption() -> SortingOptionType? {
        loader.retrieveSortingOptionFromLocal()
    }
}
