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
        XCTAssertNil(sut.getSortType())
    }
    
    func test_retrieving_sortOption_afterSaving() {
        let loader = MockUserStorage()
        let sut = LocalStorage(localStoragePresentable: loader)
        loader.saveSortTypeToLocal(SortType.popularity.rawValue)
        XCTAssertEqual(sut.getSortType(), .popularity)
    }
    
    func test_retrieving_sortOption_after_changing_sortType() {
        let loader = MockUserStorage()
        let sut = LocalStorage(localStoragePresentable: loader)
        loader.saveSortTypeToLocal(SortType.popularity.rawValue)
        loader.saveSortTypeToLocal(SortType.distance.rawValue)
        XCTAssertEqual(sut.getSortType(), .distance)
    }
}

final class MockUserStorage: LocalStoragePresentable {
   
    private var sortType: Int?

    func saveSortTypeToLocal(_ rawValue: Int) {
        self.sortType = rawValue
    }
    
    func retrieveSortTypeFromLocal() -> SortType? {
        guard let rawValue = sortType else {
            return nil
        }
        return SortType(rawValue: rawValue)
    }
}
