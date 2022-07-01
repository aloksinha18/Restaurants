//
//  SortingOptionsManager.swift
//  Restaurants
//
//  Created by Alok Sinha on 2022-07-01.
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
