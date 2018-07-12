//
//  BoxTests.swift
//  BoxTests
//
//  Created by Francis on 2018/7/12.
//  Copyright © 2018年 hao yin. All rights reserved.
//

import XCTest
@testable import Box
class BoxTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let b = BlockBox(width: 0, height: 0)
        b.needFitSize = true
//        b.padding = Margin(left: 10, right: 10, top: 10, bottom: 10)
        for i in (0 ..< 10) {
            if i % 3 == 0{
                let a = BlockBox(width: CGFloat(100 + i), height: CGFloat(100 + i))
                
//                a.margin = Margin(left: 1, right: 2, top: 3, bottom: 4)
                b.addSubBox(box: a)
            }else{
                let a = BlockBox(width: CGFloat(100 + i), height: CGFloat(100 + i))
//                a.margin = Margin(left: 1, right: 2, top: 3, bottom: 4)
                a.display = .Inline
                b.addSubBox(box: a)
            }
        }
        b.fixSize()
        print(b.resultRect)
        print(b.subBoxs.map({ (i) -> CGRect in
            i.resultRect
        }))
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
