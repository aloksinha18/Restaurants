//
//  LocalStorage.swift
//  Restaurants
//
//  Created by Alok Sinha on 2022-06-30.
//

import Foundation

struct LocalStorage: SortingOptionsManager {
    private let localStoragePresentable: LocalStoragePresentable
    
    init(localStoragePresentable: LocalStoragePresentable) {
        self.localStoragePresentable = localStoragePresentable
    }
    
    func save(_ rawValue: Int) {
        localStoragePresentable.saveSortingOptionToLocal(rawValue)
    }
    
    func getSortingOption() -> SortingOptionType? {
        localStoragePresentable.retrieveSortingOptionFromLocal()
    }
}


struct UserDefaultStorage: LocalStoragePresentable {
    static let key = "sortOption"
    
    let userDefault = UserDefaults.standard
    
    func saveSortingOptionToLocal(_ rawValue: Int) {
        userDefault.set(rawValue, forKey: UserDefaultStorage.key)
    }
    
    func retrieveSortingOptionFromLocal() -> SortingOptionType? {
        if let rawValue =  userDefault.value(forKey: UserDefaultStorage.key) as? Int, let filter = SortingOptionType(rawValue: rawValue) {
            return filter
        }
        return nil
    }
}
