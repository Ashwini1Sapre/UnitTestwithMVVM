//
//  UnitTestwithMVVMTests.swift
//  UnitTestwithMVVMTests
//
//  Created by Knoxpo MacBook Pro on 24/12/20.
//

import XCTest
@testable import UnitTestwithMVVM

class UnitTestwithMVVMTests: XCTestCase {
    
    var service : APIService!
    
    override func setUp() {
        service = APIService()
    }
    override func tearDown() {
        service = nil
    }
    
    func fetchpopulatephotos()
    {
        let expection = XCTestExpectation(description: "call back api")
        
        service.fetchPopularPhoto(complete: { (success, photos ,error) in
            
            
            expection.fulfill()
            XCTAssertEqual(photos.count, 20)
            for photo in photos
            {
                XCTAssertNotNil(photo.id)
               
            }
            
            
            
            
        })
        wait(for: [expection], timeout: 3.0)
        
        
        
    }
        
}
    
    

    
