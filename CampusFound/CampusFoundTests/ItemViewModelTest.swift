//
//  ItemViewModelTest.swift
//  CampusFound
//
//  Created by Adrian Ninanya on 11/30/25.
//

import XCTest
@testable import CampusFound

final class ItemsViewModelTest: XCTestCase {

    var sut: ItemsViewModel!   // system under test

    override func setUp() {
        super.setUp()
        sut = ItemsViewModel()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testSeedFakeDataLoadsTwoItems() {
        XCTAssertEqual(sut.items.count, 2)
    }

    func testAddItemIncreasesItemsCount() {
        let initialCount = sut.items.count
        
        sut.addItem(
            title: "Wallet",
            description: "Black leather wallet",
            building: "Library",
            status: .lost,
            ownerEmail: "test@suu.edu"
        )

        XCTAssertEqual(sut.items.count, initialCount + 1)
    }

    func testFilteredItemsWithSearchText() {
        sut.searchText = "airpods"

        let results = sut.filteredItems

        XCTAssertEqual(results.count, 1)
        XCTAssertTrue(results.first?.title.contains("AirPods") ?? false)
    }

    func testFilteredItemsByStatus() {
        sut.selectedStatus = .lost

        let results = sut.filteredItems

        XCTAssertTrue(results.allSatisfy { $0.status == .lost })
    }

    func testFilteredItemsByBuilding() {
        sut.selectedBuilding = "Geoscience Building"

        let results = sut.filteredItems

        XCTAssertTrue(results.allSatisfy { $0.building == "Geoscience Building" })
    }

    func testFilteredItemsAreSortedByDateDescending() {
        let items = sut.filteredItems
        XCTAssertTrue(items[0].date >= items[1].date)
    }

    func testMarkReturnedChangesStatus() {
        let item = sut.items.first!
        XCTAssertNotEqual(item.status, .returned)

        sut.markReturned(item)

        XCTAssertEqual(sut.items.first?.status, .returned)
    }
}
