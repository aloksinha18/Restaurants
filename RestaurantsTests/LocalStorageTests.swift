//
//  LocalStorageTests.swift
//  RestaurantsTests
//
//  Created by Alok Sinha on 2022-06-30.
//

import XCTest
@testable import Restaurants

final class LocalStorageTests: XCTestCase {
    
    func test_retriveing_sortOption_return_nil(){
        let loader = MockUserStorage()
        let sut = LocalStorage(loader: loader)
        XCTAssertNil(sut.getFilter())
    }
    
    func test_retriveing_sortOption_saving() {
        let loader = MockUserStorage()
        let sut = LocalStorage(loader: loader)
        loader.saveToLocal(FilterType.popularity.rawValue)
        XCTAssertEqual(sut.getFilter(), .popularity)
    }
    
    func test_retriveing_sortOption_after_changing_sortType() {
        let loader = MockUserStorage()
        let sut = LocalStorage(loader: loader)
        loader.saveToLocal(FilterType.popularity.rawValue)
        loader.saveToLocal(FilterType.distance.rawValue)
        XCTAssertEqual(sut.getFilter(), .distance)
    }
}

final class MockUserStorage: LocalStoragePresentable {
   
    private var filterType: Int?

    func saveToLocal(_ rawValue: Int) {
        self.filterType = rawValue
    }
    
    func retrieveFilterFromLocal() -> FilterType? {
        guard let rawValue = filterType else {
            return nil
        }
        return FilterType(rawValue: rawValue)
    }
}
