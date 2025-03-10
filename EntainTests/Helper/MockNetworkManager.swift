//
//  MockNetworkManager.swift
//  Warning: Contents may be more confusing than they appear.
//  Powered by caffeine and desperation.
//  Created by Chirag Chaplot on 10/3/2025.
//  Copyright © 2025 Chirag Chaplot Pvt Ltd. All rights reserved.
//
    
import Foundation
@testable import Entain

class MockNetworkManager: NetworkService {
  var mockResponseData: Data?
  var mockError: Error?
  
  func fetch<T: Decodable>(url: URL?, responseType: T.Type) async throws -> T {
    if let error = mockError {
      throw error
    }
    
    guard let data = mockResponseData else {
      throw NetworkError.noData
    }
    
    do {
      return try JSONDecoder().decode(T.self, from: data)
    } catch {
      throw NetworkError.decodingFailed(error.localizedDescription)
    }
  }
}
