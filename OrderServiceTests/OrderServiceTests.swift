//
//  OrderServiceTests.swift
//  OrderServiceTests
//
//  Created by Robert Latta on 7/1/19.
//  Copyright © 2019 rl. All rights reserved.
//

import XCTest
@testable import OrderService

class OrderServiceTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDatabaseOpen()
    {
        let dataBaseConnect : DatabaseManager = DatabaseManager()
        let test = dataBaseConnect.OpenDatabaseConnection()
        assert(test != nil)
        
    }
    
    func testDatabaseRead()
    {
        let dataBaseConnect : DatabaseManager = DatabaseManager()
    }
    
    

}
