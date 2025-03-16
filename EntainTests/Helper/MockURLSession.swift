//
//  MockURLSession.swift
//  Warning: Contents may be more confusing than they appear.
//  Powered by caffeine and desperation.
//  Created by Chirag Chaplot on 10/3/2025.
//  Copyright © 2025 Chirag Chaplot Pvt Ltd. All rights reserved.
//

import Foundation
@testable import Entain

/// A mock URLSession that allows us to control the responses in tests
final class MockURLSession: URLSessionProtocol {
  var data: Data?
  var response: URLResponse?
  var error: Error?
  
  func data(for request: URLRequest) async throws -> (Data, URLResponse) {
    if let error = error {
      throw error
    }
    
    guard let data = data, let response = response else {
      throw NetworkError.unknown(NSError(domain: "MockError", code: -1))
    }
    
    return (data, response)
  }
}


// MARK: - Mock Objects

/// Sample model to decode in tests
struct MockModel: Decodable, Equatable {
    let id: Int
    let name: String
}
