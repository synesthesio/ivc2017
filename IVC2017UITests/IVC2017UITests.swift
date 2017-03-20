//
//  IVC2017UITests.swift
//  IVC2017UITests
//
//  Created by synesthesia on 3/19/17.
//  Copyright © 2017 com.ivc.FirebaseDatabase. All rights reserved.
//

import XCTest

class IVC2017UITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
			let app = XCUIApplication()
			setupSnapshot(app)
			app.launch()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
		snapshot("0Launch")
		
//		let tabBar = XCUIApplication().tabBars
//		let firstBut = tabBar.buttons.element(boundBy:0)
//		let secondBut = tabBar.buttons.element(boundBy:1)
//		let thirdBut = tabBar.buttons.element(boundBy:2)
//		let fourthBut = tabBar.buttons.element(boundBy:3)
//		let fifthBut = tabBar.buttons.element(boundBy:4)
//		
		
		
		
				// This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
