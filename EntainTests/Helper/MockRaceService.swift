//
//  MockRaceService.swift
//  Warning: Contents may be more confusing than they appear.
//  Powered by caffeine and desperation.
//  Created by Chirag Chaplot on 10/3/2025.
//  Copyright © 2025 Chirag Chaplot Pvt Ltd. All rights reserved.
//

import Foundation
@testable import Entain

class MockRaceService: RaceServiceProtocol {
  var mockResponse: RaceResponse?
  var mockError: Error?
  
  func fetchNextRaces(count: Int) async throws -> RaceResponse {
    if let error = mockError {
      throw error
    }
    
    guard let response = mockResponse else {
      throw NetworkError.noData
    }
    
    return response
  }
}
