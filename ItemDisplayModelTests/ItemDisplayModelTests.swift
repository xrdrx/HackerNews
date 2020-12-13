//
//  ItemDisplayModelTests.swift
//  ItemDisplayModelTests
//
//  Created by Aleksandr Svetilov on 13.12.2020.
//

import XCTest
@testable import HackerNews

class ItemDisplayModelTests: XCTestCase {
    var model: ItemDisplayModel!
    
    override func setUp() {
        super.setUp()
        model = ItemDisplayModel()
    }
    
    override func tearDown() {
        model = nil
        super.tearDown()
    }

    func testEmptyIdListReturnsZeroTableRows() {
        let rows = model.getNumberOfRowsInSection()
        
        XCTAssertTrue(rows == 0)
    }
    
    func testGetNumberOfRows() {
    }

}
