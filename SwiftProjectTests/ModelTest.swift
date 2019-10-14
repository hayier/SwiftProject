//
//  ModelTest.swift
//  SwiftProjectTests
//
//  Created by tongcheng on 2019/5/5.
//  Copyright © 2019 icx. All rights reserved.
//

import XCTest
@testable import SwiftProject
import MJExtension
import Alamofire

class ModelTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let dic:[String : Any] = ["name":"name","age":5,"book":["name":"name","page":3]]
        let u = UserExsample().mj_setKeyValues(dic)!
        
        print(u.name!,u.age,u.bookModel!.name!,u.bookModel!.page)
    
    }
    
    func testRegex(){
        
        let str = "%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3Cp%3E%3Cimg%20src=%22http://localhost:49710/images/Product/Detail_7620190516154650848.jpg%22%20alt=%22Details%22%20style=%22max-width:100%25;%22%3E%3Cbr%3E%3C/p%3E%3Cp%3E%3Cbr%3E%3C/p%3E,%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3Cp%3E%3Cimg%20src=%22http://localhost:49710/images/Product/Detail_7620190516154650848.jpg%22%20alt=%22Details%22%20style=%22max-width:100%25;%22%3E%3Cbr%3E%3C/p%3E%3Cp%3E%3Cbr%3E%3C/p%3E"
        //(http[^\s]+(jpg|jpeg|png|tiff)\b)
        //images[^\\s]+(jpg)\\b
        let s = str.removingPercentEncoding!
        
        print(s)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
