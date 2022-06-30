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
        loader.saveToLocal(.popularity)
        XCTAssertEqual(sut.getFilter(), .popularity)
    }
    
    func test_retriveing_sortOption_after_changing_sortType() {
        let loader = MockUserStorage()
        let sut = LocalStorage(loader: loader)
        loader.saveToLocal(.popularity)
        loader.saveToLocal(.distance)
        XCTAssertEqual(sut.getFilter(), .distance)
    }
}

final class MockUserStorage: LocalStoragePresentable {
    
    private var filterType: FilterType?

    func saveToLocal(_ filter: FilterType) {
        self.filterType = filter
    }
    
    func retrieveFilterFromLocal() -> FilterType? {
        return filterType
    }
}
