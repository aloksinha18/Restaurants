//
//  LocalStorageTests.swift
//  RestaurantsTests
//
//  Created by Alok Sinha on 2022-06-30.
//

import XCTest
@testable import Restaurants

final class LocalStorageTests: XCTestCase {
    
    func test_retrieving_sortOption_return_nil(){
        let loader = MockUserStorage()
        let sut = LocalStorage(localStoragePresentable: loader)
        XCTAssertNil(sut.getSortingOption())
    }
    
    func test_retrieving_sortOption_afterSaving() {
        let loader = MockUserStorage()
        let sut = LocalStorage(localStoragePresentable: loader)
        loader.saveSortingOptionToLocal(SortingOptionType.popularity.rawValue)
        XCTAssertEqual(sut.getSortingOption(), .popularity)
    }
    
    func test_retrieving_sortOption_after_changing_sortType() {
        let loader = MockUserStorage()
        let sut = LocalStorage(localStoragePresentable: loader)
        loader.saveSortingOptionToLocal(SortingOptionType.popularity.rawValue)
        loader.saveSortingOptionToLocal(SortingOptionType.distance.rawValue)
        XCTAssertEqual(sut.getSortingOption(), .distance)
    }
}

final class MockUserStorage: LocalStoragePresentable {
   
    private var filterType: Int?

    func saveSortingOptionToLocal(_ rawValue: Int) {
        self.filterType = rawValue
    }
    
    func retrieveSortingOptionFromLocal() -> SortingOptionType? {
        guard let rawValue = filterType else {
            return nil
        }
        return SortingOptionType(rawValue: rawValue)
    }
}
