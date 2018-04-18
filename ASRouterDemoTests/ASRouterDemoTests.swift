//
//  ASRouterDemoTests.swift
//  ASRouterDemoTests
//
//  Created by Think on 16/04/2018.
//  Copyright © 2018 Think. All rights reserved.
//

import XCTest
@testable import ASRouterDemo

class ASRouterDemoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        var shared = ASRouter.shared
        shared.map(route: "/user/:userId/", toControllerClass: ViewController.classForCoder())
        let vc = shared.matchController("/user/2/")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
