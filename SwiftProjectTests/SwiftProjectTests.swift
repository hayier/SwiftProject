//
//  SwiftProjectTests.swift
//  SwiftProjectTests
//
//  Created by tongcheng on 2019/5/5.
//  Copyright © 2019 icx. All rights reserved.
//

import XCTest
@testable import SwiftProject

class SwiftProjectTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
       
        let data = AddressModel.getCitys()
    
        print(data)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
