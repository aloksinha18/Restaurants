//
//  LocalStorage.swift
//  Restaurants
//
//  Created by Alok Sinha on 2022-06-30.
//

import Foundation

struct LocalStorage: SortTypeManager {
    private let localStoragePresentable: LocalStoragePresentable
    
    init(localStoragePresentable: LocalStoragePresentable) {
        self.localStoragePresentable = localStoragePresentable
    }
    
    func save(_ rawValue: Int) {
        localStoragePresentable.saveSortTypeToLocal(rawValue)
    }
    
    func getSortType() -> SortType? {
        localStoragePresentable.retrieveSortTypeFromLocal()
    }
}


struct UserDefaultStorage: LocalStoragePresentable {
    static let key = "sortOption"
    
    let userDefault = UserDefaults.standard
    
    func saveSortTypeToLocal(_ rawValue: Int) {
        userDefault.set(rawValue, forKey: UserDefaultStorage.key)
    }
    
    func retrieveSortTypeFromLocal() -> SortType? {
        if let rawValue =  userDefault.value(forKey: UserDefaultStorage.key) as? Int, let sortingType = SortType(rawValue: rawValue) {
            return sortingType
        }
        return nil
    }
}
