//
//  SwfitTestProjTests.swift
//  SwfitTestProjTests
//
//  Created by mac on 2020/8/21.
//  Copyright © 2020 mac. All rights reserved.
//

import XCTest
@testable import SwfitTestProj

class SwfitTestProjTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        XCTAssertNoThrow(HttpMgr.GlobalHttpGet(urlstr: "www.baidu.com", success: { (strData) in
        }, fail: { (error) in
        }), "---warning, HttpMgr.GlobalHttpGet have some throw!!!")
        
        XCTAssertNoThrow(UserData.globalGetIns().loadUserData(), "---warning, load user data process have some throw!!!")
        
        var sentence = ""
        for someType in ESentenceType.allCases {
            sentence = GlobalGetSentence(sentenceType: someType)
            XCTAssertTrue(!sentence.isEmpty, "---waining, some sentence is empty!!!")
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            UserData.globalGetIns().loadUserData()
        }
    }

}
