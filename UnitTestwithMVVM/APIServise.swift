//
//  APIServise.swift
//  UnitTestwithMVVM
//
//  Created by Knoxpo MacBook Pro on 24/12/20.
//

import Foundation

enum APIError: String,Error
{
    case noNetwork = "No network"
    case serverOvewrload = "server overloaded"
    case permissionDENIED = "not permission"
    
    
}

protocol APIServiceProtocol {
    func fetchPopularPhoto( complete: @escaping ( _ success: Bool, _ photos: [Photo], _ error: APIError? )->() )
}

class APIService: APIServiceProtocol {
    // Simulate a long waiting for fetching
    func fetchPopularPhoto( complete: @escaping ( _ success: Bool, _ photos: [Photo], _ error: APIError? )->() ) {
        DispatchQueue.global().async {
            sleep(3)
            let path = Bundle.main.path(forResource: "content", ofType: "json")!
            
            
            let data = try! Data(contentsOf: URL(fileURLWithPath: path))
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let photos = try! decoder.decode(Photos.self, from: data)
            complete( true, photos.photos, nil )
        }
    }
    
    
    
}

    
    
    
    
    

