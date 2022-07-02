//
//  RestaurantsUITests.swift
//  RestaurantsUITests
//
//  Created by Alok Sinha on 2022-06-26.
//

import XCTest

final class RestaurantsUITests: XCTestCase {
    
    func test_restaurantsList_table() {
        let app = XCUIApplication()
        app.launch()
        let table = app.tables[AccessibilityIdentifiers.tableView]
        XCTAssertEqual(table.cells.count, 19)
    }
    
    func test_sortingTypes() {
        let app = XCUIApplication()
        app.launch()
        let button = app.buttons[AccessibilityIdentifiers.sortOptions]
        button.tap()
        let table = app.tables[AccessibilityIdentifiers.tableView]
        XCTAssertEqual(table.cells.count, 8)
        
        let expectedSortTypes = ["Best match", "Newest", "Rating average", "Distance", "Popularity", "Average product price", "Delivery costs", "Minimum cost"]
        
        for (index, element) in expectedSortTypes.enumerated() {
            let cells = table.cells
            let cell = cells.element(boundBy: index)
            cell.assetContains(text: element)
        }
    }
    
    func test_result_AfterSearch() {
        let app = XCUIApplication()
        app.launch()
        let table = app.tables[AccessibilityIdentifiers.tableView]
        let searchBar = app.navigationBars.searchFields["Search"]
        searchBar.tap()
        searchBar.typeText("Roti")
        XCTAssertEqual(table.cells.count, 1)
        
        let cell = table.cells.element(boundBy: 0)
        cell.assetContains(text: "Roti")
    }
    
    func test_result_after_cancellingSearch() {
        let app = XCUIApplication()
        app.launch()
        let table = app.tables[AccessibilityIdentifiers.tableView]
        let searchBar = app.navigationBars.searchFields["Search"]
        searchBar.tap()
        searchBar.typeText("Roti")
        XCTAssertEqual(table.cells.count, 1)
        
        let cell = table.cells.element(boundBy: 0)
        cell.assetContains(text: "Roti")
        app.navigationBars.buttons["Cancel"].tap()
        XCTAssertEqual(table.cells.count, 19)
    }
}

private extension XCUIElement {
    func assetContains(text: String) {
        let predicate = NSPredicate(format: "label CONTAINS[c] %@", text)
        let element = staticTexts.containing(predicate)
        XCTAssertTrue(element.count > 0)
    }
}
