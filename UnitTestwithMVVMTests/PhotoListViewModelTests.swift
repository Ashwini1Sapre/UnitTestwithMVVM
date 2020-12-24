//
//  PhotoListViewModelTests.swift
//  UnitTestwithMVVMTests
//
//  Created by Knoxpo MacBook Pro on 24/12/20.
//

import XCTest

@testable import UnitTestwithMVVM

class PhotoListViewModelTests: XCTestCase {
    
    var viewmodel: PhotoListViewModel!
    var mockAPIService: MockApiService!
    
    override func setUp() {
       
       mockAPIService = MockApiService()
        viewmodel = PhotoListViewModel (apiService: mockAPIService)
    }
    
    
    override func tearDown() {
        viewmodel = nil
        mockAPIService = nil
    
    }

    func test_fetch_photo()
    {
        
        mockAPIService.completePhotos = [Photo]()
        viewmodel.initfech()
        XCTAssert(mockAPIService!.isFetchPopularPhotoCalled)
        
        
    }
    
    
    func test_fetch_photo_fail() {
        
        let error = APIError.permissionDENIED
        viewmodel.initfech()
        mockAPIService.fetchFail(error: error)
        XCTAssertEqual(viewmodel.alertMessage, error.rawValue)
        
        
        
    }
    
    
    
    func testfetchcellforTable()
    {
        
        let photos = StunGenerator().stunPhoto()
        
        mockAPIService.completePhotos = photos
        let expect = XCTestExpectation(description: "reload clouser")
        viewmodel.reloadTableviewClouser = { () in
            
            expect.fulfill()
        }
        
        viewmodel.initfech()
        mockAPIService.fetchSuccess()
        XCTAssertEqual(viewmodel.numberOfCells, photos.count)
        wait(for: [expect], timeout: 1.0)
        
        
        
    }
    
    
    
    
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}


class MockApiService: APIServiceProtocol {
    
    var isFetchPopularPhotoCalled = false
    
    var completePhotos: [Photo] = [Photo]()
    var completeClosure: ((Bool, [Photo], APIError?) -> ())!
    
    func fetchPopularPhoto(complete: @escaping (Bool, [Photo], APIError?) -> ()) {
        isFetchPopularPhotoCalled = true
        completeClosure = complete
        
    }
    
    func fetchSuccess() {
        completeClosure( true, completePhotos, nil )
    }
    
    func fetchFail(error: APIError?) {
        completeClosure( false, completePhotos, error )
    }
    
}

class StunGenerator{
    
    func stunPhoto() -> [Photo]
    {
        let path = Bundle.main.path(forResource: "content", ofType: "json")!
        
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        let decoder = JSONDecoder()
        
        decoder.dateDecodingStrategy = .iso8601
        
        let photos = try! decoder.decode(Photos.self, from: data)
        
        return photos.photos
        
        
        
        
    }
    
    
    
    
    
    
}
