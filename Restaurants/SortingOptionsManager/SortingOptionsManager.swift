//
//  SortTypeManager.swift
//  Restaurants
//
//  Created by Alok Sinha on 2022-07-01.
//

import Foundation

protocol SortTypeManager {
    func save(_ rawValue: Int)
    func getSortType() -> SortType?
}

protocol LocalStoragePresentable {
    func saveSortTypeToLocal(_ rawValue: Int)
    func retrieveSortTypeFromLocal() -> SortType?
}
